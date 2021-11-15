import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts


IconButton {
    property string tipText

    backgroundColor: Constant.framebar_color
    width: parent.width
    height: 50
    icon{
        width: 30
        height: 30
    }

    ToolTip{
        Text{
            text: tipText
            color: "#dddddd"
        }
        visible: hovered
        background: Rectangle{
            color: "#303030"
        }
        x: background.x + 48
        y: background.y + 10
    }

}