import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts


 
//自定义标题栏
Rectangle{
    property var mainWindow
    readonly property string icon_color: "#cccccc"
    readonly property string iconBackgroundHoverColor: "#666666"
    property int barHeight: 32
    property int iconWidth: 40

    id: mainTitle
    x:0
    y:0
    width: mainWindow.width
    height: barHeight
    color: Constant.titlebar_color
    //记录鼠标移动的位置，此处变量过多会导致移动界面变卡
    property point  clickPos: "0,0"

    Layout.topMargin: 0
    Layout.fillWidth: true

    // anchors.top: parent.top
    // anchors.right: parent.right
    // anchors.left: parent.left
    

    function resizeIcon() {
        if(mainWindow.visibility === Window.Maximized || mainWindow.visibility === Window.FullScreen){
            return "./icons/normal.svg"
        }
        return "./icons/maximize.svg"
    }

    function resizeWindow(){
        if(mainWindow.visibility === Window.Maximized || mainWindow.visibility === Window.FullScreen){
            mainWindow.visibility = Window.Windowed
        }else{
            mainWindow.visibility = Window.Maximized
        }
        
    }

    //处理鼠标移动后窗口坐标逻辑
    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton  //只处理鼠标左键
        onPressed: {    //鼠标左键按下事件
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: (mouse)=> {    //鼠标位置改变
            //计算鼠标移动的差值
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            //设置窗口坐标
            mainWindow.setX(root.x + delta.x)
            mainWindow.setY(root.y + delta.y)
        }
    }

    IconButton {
        iconPath: "./icons/logo.svg"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 2
        iconColor: "#43acF2"
        backgroundColor: Constant.titlebar_color
        width: 29
        height: 29
    }

    //关闭窗口按钮
    IconButton {
        id: closeButton
        iconPath: "./icons/close.svg"
        iconColor: icon_color
        backgroundColor: Constant.titlebar_color
        backgroundHoverColor: "red"
        x:0
        anchors.right: parent.right
        width: iconWidth
        height:  barHeight

        MouseArea{
            anchors.fill: parent
            onClicked: {
                Qt.quit()               //退出程序
            }
        }
    }

    //最大化窗口按钮
    IconButton {
        id: maxButton
        iconPath: resizeIcon()
        iconColor: icon_color
        backgroundHoverColor: iconBackgroundHoverColor
        backgroundColor: Constant.titlebar_color
        x: 0
        anchors.right: closeButton.left
        anchors.rightMargin: 1
        width: iconWidth
        height:  barHeight

        MouseArea{
            anchors.fill: parent
            onClicked: {
                resizeWindow()        //窗口最小化
            }
        }
    }

    //最小化窗口按钮
    IconButton {
        id: minButton
        iconPath: "./icons/minimize.svg"
        iconColor: icon_color
        backgroundColor: Constant.titlebar_color
        backgroundHoverColor: iconBackgroundHoverColor
        x: 0
        anchors.right: maxButton.left
        anchors.rightMargin: 1
        width: iconWidth
        height:  barHeight

        MouseArea{
            anchors.fill: parent
            onClicked: {
                mainWindow.showMinimized()        //窗口最小化
            }
        }
    }

}