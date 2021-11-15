import QtQuick
import QtQuick.Controls

Button {
    property string iconPath
    property string iconColor: "#858585"
    property string iconHoverColor: "white"
    property string backgroundColor: Constant.framebar_color
    property string backgroundHoverColor: Constant.framebar_color


    id: iconButton
    highlighted: false
    flat: true
    // anchors.fill:parent
    state: "RELEASED"
    background: Rectangle{
        color: backgroundColor
    }
    // width: 80
    // height: 80

    icon {
      source:  Qt.resolvedUrl(iconPath)
      width: 30
      height: 30
    }

    MouseArea { 
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor 
    }

    // PropertyAnimation {id: animateColor1;  target: iconButton; properties: "icon.color"; to: "blue"; duration: 300}
    // PropertyAnimation {id: animateColor2; target: iconButton; properties: "icon.color"; to: "red"; duration: 300}

    HoverHandler {
      onHoveredChanged: {
        if(hovered){
          iconButton.state = "PRESSED"
          // animateColor1.start()
        //   iconButton.background.color = "yellow"
        }else{
          // animateColor2.start()
          iconButton.state = "RELEASED"
        }
      }
    }

    states: [
        State {
            name: "PRESSED"
            PropertyChanges { target: iconButton; icon.color: iconHoverColor; background.color: backgroundHoverColor}
        },
        State {
            name: "RELEASED"
            PropertyChanges { target: iconButton; icon.color: iconColor; background.color: backgroundColor}
        }
    ]

    transitions: [
        Transition {
            from: "PRESSED"
            to: "RELEASED"
            ColorAnimation { target: iconButton; duration: 300}
        },
        Transition {
            from: "RELEASED"
            to: "PRESSED"
            ColorAnimation { target: iconButton; duration: 300}
        }
    ]

    

  }