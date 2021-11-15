import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.12


ApplicationWindow {
    id: mainWindow
    visible: true
    width: Screen.desktopAvailableWidth * 0.8
    height: Screen.desktopAvailableHeight * 0.8
    title: qsTr("Python料理师")

    RowLayout{
        id: mainLayout
        anchors.fill: parent
        spacing: 0

        IconBar{
            id: iconBar
            color: '#515151'
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
        }

    }


}
