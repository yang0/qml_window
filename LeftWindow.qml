import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle{
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: TaskWindow{
            id: taskWindow
        }

        
        Component.onCompleted: {
            console.log("stackview.height: " + stackView.height)
        }
        
    }



}
