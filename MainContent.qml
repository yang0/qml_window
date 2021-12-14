import QtQuick
import QtQuick.Controls

SplitView {
    anchors.fill: parent
    orientation: Qt.Horizontal
    spacing: 0
    property string centerColor: "#1e1e1e"

    handle: Rectangle {
        implicitWidth: 4
        implicitHeight: 4
        color: SplitHandle.hovered ? Constant.splitter_color : centerColor
    }

    LeftWindow {
        implicitWidth: 280
        SplitView.minimumWidth: 100
        color: "#252526"
        SplitView.fillHeight: true
        
        
        
        // Text {
        //     text: "View 1"
        //     anchors.centerIn: parent
        // }
    }

    Rectangle {
        id: centerItem
        SplitView.minimumWidth: 200
        SplitView.fillWidth: true
        color: "blue"//centerColor
        Text {
            text: "View 2"
            anchors.centerIn: parent
        }
    }

}