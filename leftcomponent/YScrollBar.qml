
import QtQuick 2.0


Item {
    id: scrollBar

    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    // orientation can be either Qt.Vertical or Qt.Horizontal
    property real position
    property real pageSize
    property variant orientation : Qt.Vertical
    property string backgroundColor : "white"
    property string color: "black"
    property var target
    property bool containsMouse : mouseArea.containsMouse || backgroundArea.containsMouse


    // A light, semi-transparent background
    Rectangle {
        id: background
        anchors.fill: parent
        radius: orientation == Qt.Vertical ? (width/2 - 1) : (height/2 - 1)
        color: scrollBar.backgroundColor
        opacity: 0

        MouseArea{
            id: backgroundArea
             onEntered: {
                scrollBar.opacity = scrollBar.pageSize < 1 ? 0.5 : 0
            }
            onExited: {
                if(!target.containsMouse && !scrollBar.containsMouse){
                    console.log("1")
                    scrollBar.opacity = 0
                }
            }

        }
       
    }

    // Size the bar to the required size, depending upon the orientation.
    Rectangle {
        x: orientation == Qt.Vertical ? 1 : (scrollBar.position * (scrollBar.width-2) + 1)
        y: orientation == Qt.Vertical ? (scrollBar.position * (scrollBar.height-2) + 1) : 1
        width: orientation == Qt.Vertical ? (parent.width-2) : (scrollBar.pageSize * (scrollBar.width-2))
        height: orientation == Qt.Vertical ? (scrollBar.pageSize * (scrollBar.height-2)) : (parent.height-2)
        // radius: orientation == Qt.Vertical ? (width/2 - 1) : (height/2 - 1)
        color: scrollBar.color
        opacity: 0.7


        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            drag.target: parent;
            drag.axis: Drag.YAxis
            drag.minimumY: 0
            drag.maximumY: scrollBar.height - parent.height
            onEntered: {
                scrollBar.opacity = scrollBar.pageSize < 1 ? 0.5 : 0
            }
            onExited: {
                if(!pressed && !target.containsMouse && !scrollBar.containsMouse){
                    scrollBar.opacity = 0
                }
                
            }
            onPressed: {
                // parent.color = Qt.darker("#6D665C")
            }
            onReleased: {
                // console.log("mouse released , target.containsMouse:" + target.containsMouse + " scrollBar.containsMouse: " + scrollBar.containsMouse)
                if(!target.containsMouse && !scrollBar.containsMouse){
                    scrollBar.opacity = 0
                }
                // parent.color = "#6D665C"
                // if(!mouseArea.containsMouse)
                // fadeOut.start()
            }
            onMouseYChanged: {
                // opacity = scrollBar.pageSize < 1 ? 0.5 : 0
                if(pressed){
                    target.contentY = parent.y / scrollBar.height * target.contentHeight
                }
            }
        }
    }

    Timer {
        id: timer
        interval: 5000; running: false; repeat: false
        onTriggered: opacity = 0
    }

    function stopTimer(){
        timer.stop()
    }

    function disp(){
        if(!scrollBar) return
        opacity = scrollBar.pageSize < 1 ? 0.5 : 0
        if(opacity > 0){
            timer.restart()
        }
    }

    Component.onCompleted:{
        parent.heightChanged.connect(disp)
    }
}
