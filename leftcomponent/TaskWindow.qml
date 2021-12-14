import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"

Rectangle{
    id: outerRect
    property int scrollbarWidth: 10
    anchors.fill: parent
    color: Constant.border_color

    function printHeight(){
        console.log("===========================================")
        console.log("[outerRect] height: " + height)
        console.log("[page] contentHeight: " + page.contentHeight + " / contentWidth: " + page.contentWidth + " / height: " + page.height + " / width: " + page.width)
        console.log("[cl] height: " + cl.height + "  / implicitHeight: " + cl.implicitHeight + " / width: " + cl.width)
        console.log("===========================================")
    }

    function setLayoutHeight(){
        var totalHeight = 0
        for (var i = 0; i < cl.accordionNodes.length; i++){
            var node = cl.accordionNodes[i]
            totalHeight += node.current ? node.expandMinimumHeight : node.fixedHeight
        }

        cl.implicitHeight = totalHeight > outerRect.height ? totalHeight : outerRect.height
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        // propagateComposedEvents: true
        onEntered:{
            console.log("outerrect in")
            verticalScrollBar.opacity = page.visibleArea.heightRatio < 1 ? 0.5 : 0
            verticalScrollBar.stopTimer()
        }

        onExited:{
            console.log("outerrect out")
            if(!verticalScrollBar.containsMouse){
                verticalScrollBar.opacity = 0

            }
                
        }
    }


    Flickable {
        id: page
        property bool containsMouse: mouseArea.containsMouse
        anchors.fill: parent
        contentHeight: cl.implicitHeight
        contentWidth: width
        clip: true

        onContentYChanged:{
            if(contentHeight <= height){
                contentY = 0
                return
            }
            // console.log("contentY: " + contentY + " atYBeginning:" + atYBeginning + " atYEnd:" + atYEnd + " height:" + height + "  contentHeight:" + contentHeight )
            if(atYBeginning && contentY !== 0) contentY = 0
            if(atYEnd) contentY = contentHeight - height
        }

        ColumnLayout{
            id: cl
            property var scroll: page
            anchors.fill: page
            anchors.top: page.top
            anchors.bottom: page.bottom
            anchors.left: page.left
            anchors.right: page.right

            spacing: 1
            property var accordionNodes: []
            implicitWidth: page.width
            width: page.width

            AccordionWidget{
                id: taskList
                title: "所有任务"

                

                TaskTree {
                    id: taskTree

                    onHoveredChanged:{
                        console.log("focus: " + focus)
                        console.log("hovered: " + hovered)
                        taskList.treeIconLine.visible = hovered
                    }
                }


                // iconModel: ListModel{
                //     ListElement {
                //         src: "./icons/newfile.svg"
                //     }
                //     ListElement {
                //         src: "./icons/newfolder.svg"
                //     }
                // }
                

                // Rectangle {
                //     color: "blue"//Constant.leftwindow_color
                //     anchors.fill: parent
                // }
            }

            AccordionWidget {
                title: "Therapy 1"
                Rectangle {
                    color: "red"//Constant.leftwindow_color
                    anchors.fill: parent
                }
            }

            AccordionWidget {
                title: "Therapy 2"
                Rectangle {
                    color: "yellow"//Constant.leftwindow_color
                    anchors.fill: parent
                }
            }

            Rectangle {
                color: Constant.leftwindow_color
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Component.onCompleted: {
                var nodeIndex = 0
                for (var i = 0; i < children.length; i++){
                    var node = children[i]
                    if(String(node).slice(0,15) !== "AccordionWidget"){
                        continue
                    }
                    node.index = nodeIndex
                    accordionNodes[nodeIndex] = node
                    nodeIndex++
                }
                // console.log("ColumnLayout.height: " + cl.height + " width: " + cl.width + " parent.height: " + parent.height)
            }
        }

        onHeightChanged:{
            setLayoutHeight()
            // printHeight()
        }
    }


    YScrollBar {
        id: verticalScrollBar
        target: page
        width: scrollbarWidth;  height: page.height
        anchors.right: page.right
        opacity: page.visibleArea.heightRatio < 1 ? 0.5 : 0
        orientation: Qt.Vertical
        position: page.visibleArea.yPosition
        pageSize: page.visibleArea.heightRatio
        Behavior on opacity {
            PropertyAnimation { duration: 600 }
        }
        // backgroundColor: "#252526"
    }

    


    Component.onCompleted: {
        setLayoutHeight()
        // printHeight()
    }

    


}

