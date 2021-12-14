import QtQuick
import QtQuick.Controls

Rectangle {
    visible: true
    color: parent.color


    ListView {
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: 5
        spacing: 5
        
        model: IconModel {}
        delegate: SideIcon{
            iconPath: src
            tipText: tip
        }
    }


    SideIcon {
        id: settingIcon
        anchors.bottom: parent.bottom
        tipText: "系统设置"
        iconPath: "./icons/setting.svg"
    }

    SideIcon {
        anchors.bottom: settingIcon.top
        tipText: "用户中心"
        iconPath: "./icons/user.svg"
    }


    
}