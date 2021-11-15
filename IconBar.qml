import QtQuick
import QtQuick.Controls

Rectangle {
    // FontLoader { id: webFont; source: "fontawsome.otf" }
    
    // Text { text: "address-book"; font.family: webFont.name; font.pointSize: 20; color: 'red'}
    // height: 800
    // width: 300
    visible: true
    color: parent.color

    
    Component{
        id: sideIcon

        IconButton {
            iconPath: src
            backgroundColor: Constant.framebar_color
            width: parent.width
            height: 50
            anchors.bottom: tip === "系统设置" ? parent.bottom : undefined
            icon{
                width: 30
                height: 30
            }

            ToolTip{
                Text{
                    text: tip
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

    }
    
    

    ListView {
        anchors.fill: parent
        
        model: IconModel {}
        delegate: SideIcon{
            iconPath: src
            tipText: tip
        }
    }

    


    SideIcon {
        anchors.bottom: parent.bottom
        tipText: "系统设置"
        iconPath: "./icons/setting.svg"
    }


    
}