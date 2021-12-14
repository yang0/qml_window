import QtQuick 2.7
import QtQuick.Layouts 1.2
import "../"

// This widget assumes that the parent contains a currentItem property which
// points to the AccordionWidget currently selected
Item {
    id: root
    default property var contentItem: null
    property string title: "panel"
    property int index: 0
    property var accordionNodes: parent.accordionNodes

    property bool current: false
    readonly property int expandMinimumHeight: 250
    property int handleHeight: 3
    property int barHeight: 23
    property int fixedHeight: handleHeight + barHeight
    property var treeIconLine: iconLine
    Layout.fillWidth: true
    Layout.fillHeight: current
    Layout.minimumHeight: current ? expandMinimumHeight : fixedHeight
    Layout.maximumHeight:99999
    Layout.preferredHeight: fixedHeight

    // implicitHeight: fixedHeight
    property bool canZoomout: height > expandMinimumHeight && current
    property int preservedHeight: expandMinimumHeight

    property var iconModel: ListModel{
        ListElement {
            src: "./icons/newfolder.svg"
        }
         ListElement {
            src: "./icons/newfile.svg"
        }
    }
    

    // 展开或收拢当前节点
    function clickZoomItem(){
        root.current = !root.current
        if(!current){
            root.Layout.preferredHeight = fixedHeight
        }else{
            root.Layout.preferredHeight = preservedHeight
        }
        iconLine.visible = root.current

        // console.log("[clickZoomItem] " + title + " preferredHeight：" + root.Layout.preferredHeight + " height: " + height)
    }

    // 当拖拉操作可能过多时，修剪掉多余的位移值
    function fineOffsetY(srcOffsetY, itemHeight, minItemHeight){
        console.log("[fineOffsetY] srcOffsetY: " + srcOffsetY + " itemHeight:  " + itemHeight + " minItemHeight:  " + minItemHeight )
        var result = srcOffsetY
        if(itemHeight - srcOffsetY < minItemHeight){
            result = itemHeight - minItemHeight
        }

        console.log(" [fineOffsetY] result:" + result)
        return result
    }

    // 压缩Item, 返回真实的压缩值
    function dragZoomOutItem(offsetY, item){
        console.log("[dragZoomOutItem] " + item.title + " preferredHeight:" + item.Layout.preferredHeight)
        var dragUp = false
        var absOffsetY = Math.abs(offsetY)
        var minItemHeight = item.expandMinimumHeight
        if(!item.current) minItemHeight = item.fixedHeight
        var itemOffset = fineOffsetY(absOffsetY, item.height, minItemHeight)
        if(itemOffset <= 0) return 0 // 已到达最小高度，无法再压缩
        item.Layout.preferredHeight -= itemOffset //调整高度
        // item.height = item.Layout.preferredHeight
        if(offsetY  < 0){
            itemOffset = 0 - itemOffset // 再次变成负值
        }
        
        // console.log("[dragZoomOutItem] " + item.title + " offsetY: " + offsetY + "  itemOffset: " + itemOffset + " height: " + item.height + " preferredHeight:" + item.Layout.preferredHeight + " y: " + item.y)
        return itemOffset
    }

    // 判断当前节点是否能拖拉
    function canDrag(){
        var canUp = false
        var canDown = false
        var upExpandNodes = 0
        var downExpandNodes = 0

        for(var i = 0; i < root.accordionNodes.length; i++){
            if(root.index === 0) return
            var node = root.accordionNodes[i]
            if(node.index < root.index){
                if(node.current) upExpandNodes++
                if(node.canZoomout)  canUp = true
            }else{
                if(node.current) downExpandNodes++
                if(node.canZoomout) canDown = true
            }
        }
        // console.log("canUp: "+canUp+" canDown: "+canDown+" upExpandNodes: "+upExpandNodes+" downExpandNodes: "+downExpandNodes)
        if(!canUp){
            if(!canDown || upExpandNodes === 0) return false
        }else{
            if(downExpandNodes === 0) return false
        }

        return true
    }

    function upNodes(){
        //上方节点
        return accordionNodes.slice(0, root.index).reverse()
    }

    function downNodes(){
        //包括自己及下方节点
        return accordionNodes.slice(root.index)
    }

    //当前离节点最近的展开节点
    function nearestExpandedNode(isDown){
        var nodes = upNodes()
        if(isDown) nodes = downNodes()
        for(var i=0; i < nodes.length; i++){
            if(nodes[i].current) return nodes[i]
        }
    }



     MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onEntered:{
            console.log("in..")
            iconLine.visible = root.current
        }
        onExited:{
            console.log("exit" + containsMouse)
            console.log(root.contentItem)

            if(root.contentItem.hovered){
                iconLine.visible = root.focus || root.contentItem.hovered
            }else{
                iconLine.visible = root.focus
            }
            
            console.log("root.focus: " + root.focus + " root.contentItem.hovered: " + root.contentItem.hovered)
        }
        onPositionChanged:{
            iconLine.visible = root.current
        }
        
    }

    


    ColumnLayout {
        id: clayout
        anchors.fill: parent
        spacing: 0
        
        Rectangle {
            id: handle
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            implicitHeight: handleHeight
            color: Constant.leftwindow_color

            MouseArea{
                property point startPoint: Qt.point(0, 0);
                property var preNode : undefined
                property var belowNodes : []
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                onEntered:{
                    if(!canDrag()) return
                    parent.color = Constant.dragline_hover_color
                    cursorShape = Qt.SizeVerCursor;
                    
                }
                onExited:{
                    parent.color = Constant.leftwindow_color
                    cursorShape = Qt.ArrowCursor;
                }
                onPressed: (mouse)=>{
                    startPoint = Qt.point(mouse.x, mouse.y)
                    container.enableBehavior = false

                }

                onPositionChanged:(mouse)=>{
                    if(pressed && canDrag()){
                        var offsetY = mouse.y - startPoint.y;


                        var nodes = downNodes()
                        if(offsetY < 0){
                            nodes = upNodes()
                        }

                        var nearestUpNode = nearestExpandedNode(false)
                        var nearestDownNode = nearestExpandedNode(true)

                        // console.log("nodes.length:" + nodes.length)

                        for(var i = 0; i < nodes.length; i++){
                            var node = nodes[i]
                            // console.log(node.title)
                            if(node.canZoomout){
                                var itemOffset = dragZoomOutItem(offsetY, node)
                                if(offsetY > 0){
                                    nearestUpNode.Layout.preferredHeight += itemOffset    
                                }else{
                                    console.log("y值变更：" + itemOffset)
                                    root.y += offsetY - itemOffset
                                    nearestDownNode.Layout.preferredHeight += Math.abs(itemOffset)
                                }
                                
                                if(Math.abs(offsetY) < Math.abs(itemOffset)){
                                    offsetY -= itemOffset
                                }else{
                                    return
                                }
                            }
                        }

                    }
                }
            }
        }

        Rectangle {
            id: bar
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 0
            radius: 2
            Layout.fillWidth: true
            implicitHeight: barHeight
            color:  Constant.leftwindow_color
            

            IconButton {
                
                id: arrow
                anchors{
                    left: parent.left
                    verticalCenter: barTitle.verticalCenter
                }
                width: 23
                height: 23
                iconColor: "#92b3bb"
                backgroundColor: Constant.leftwindow_color
                iconPath: "./icons/arrow-right.svg"
                rotation: root.current ? "90" : 0
            }

            RowLayout{
                
                anchors{
                    left: arrow.right
                    right: parent.right
                    // bottom: parent.bottom
                    verticalCenter:parent.verticalCenter
                }

                Text {
                    id: barTitle
                    color: "#eeeeef"
                    font.pointSize: 9
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: root.title
                }

                Row{
                    id: iconLine
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 5
                    spacing: 5
                    visible: false

                    Repeater {
                        model: iconModel
                        delegate: IconButton {
                            width: 17
                            height: 17
                            iconColor: "#dddddd"
                            backgroundColor: Constant.leftwindow_color
                            iconPath: src
                        }
                    }
                }
                

            }

            

    
            // ListView{
            //     // anchors{
            //     //    left: barTitle.right
            //     // }
            //     model: iconModel
            //     orientation: ListView.Horizontal
            //     delegate: IconButton {
            //         width: 23
            //         height: 23
            //         iconColor: "#92b3bb"
            //         backgroundColor: Constant.leftwindow_color
            //         iconPath: src
            //     }
            // }

            

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                // hoverEnabled: true
                propagateComposedEvents: true
                onClicked: {
                    container.enableBehavior = true
                    clickZoomItem()
                }
            }
        }

        Rectangle {
            id: container
            Layout.alignment: Qt.AlignTop
            property bool enableBehavior: false
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumHeight: 99999
            Layout.preferredHeight: current ? root.height - root.fixedHeight : 0
            Layout.fillHeight: current
            clip: true


           
            
            
            // Behavior on implicitHeight {
            //     enabled: container.enableBehavior
            //     PropertyAnimation { duration: 200 }
            // }
        }

        Component.onCompleted: {
            if(root.contentItem !== null){
                root.contentItem.parent = container;
            }
        }
    }



    onHeightChanged:{
        if(height >= expandMinimumHeight){
            preservedHeight = height
            Layout.preferredHeight = height
        }

        var totalHeight = 0
        for (var i = 0; i < accordionNodes.length; i++){
            totalHeight += accordionNodes[i].current ? expandMinimumHeight : fixedHeight
        }

        parent.implicitHeight = totalHeight > parent.scroll.height ? totalHeight : parent.scroll.height

        // console.log("[onHeightChanged] " + title + " preferredHeight：" + root.Layout.preferredHeight + " height: " + height)
        // parent.height = parent.implicitHeight

        // console.log("parent.scroll.height :"  + parent.scroll.height)
        // console.log("parent.implicitHeight :" + parent.implicitHeight)
        // console.log("parent.height" + parent.height)
    }

    // Behavior on y {
    //     enabled: container.enableBehavior
    //     PropertyAnimation { duration: 200 }
    // }



    

    
}
