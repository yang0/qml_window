import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material


// 自定义标题栏

ApplicationWindow {
    id: root
    visible: true
    width: Screen.desktopAvailableWidth * 0.8
    height: Screen.desktopAvailableHeight * 0.8
    title: qsTr("yang0@126.com")
    flags: Qt.Window | Qt.FramelessWindowHint   //去标题栏
 
    
    
    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        TitleBar{
            id: titleBar
            mainWindow: root
        }


        RowLayout{
            id: mainLayout
            spacing: 0
            Layout.bottomMargin: 0

            IconBar{
                id: iconBar
                color: Constant.framebar_color
                // anchors.top: parent.mainTitle.bottom
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 50
                Layout.preferredWidth: 50
            }

            

            Rectangle{
                id: iconBar2
                color: 'plum'
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: parent.width - iconBar.width
                MainContent{
                }
            }

        }

        transitions: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad }
        }

    }
    
    ResizeBorder{
        target: root
    }

    
}