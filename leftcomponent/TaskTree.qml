import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../treeview"

Rectangle{
    
    anchors.fill: parent
    property bool hovered: tree.hovered

    readonly property string iconName: "ico_item.png"


    TreeWidget{
        id: tree
        anchors.fill: parent

        Component.onCompleted: {
            iconSize = (Qt.size(12, 12));
            font.family = "Monaco";
            font.pointSize = 16;

            var topItem1 = createItem("Item 1", iconName);
            topItem1.setSelectionFlag(selectionCurrent);
            addTopLevelItem(topItem1);

            topItem1.appendChild(createItem("Child 1", iconName));
            topItem1.appendChild(createItem("Child 2", iconName));
            topItem1.appendChild(createItem("Child 3", iconName));

            addTopLevelItem(createItem("Item 2", iconName));
            addTopLevelItem(createItem("Item 3", iconName));
        }

        onCurrentItemChanged: {
            var item = getCurrentItem();
            // if(item) inputName.text = item.text();
        }

    }
}