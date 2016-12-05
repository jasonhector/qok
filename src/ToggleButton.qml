           
import QtQuick 1.0

   Rectangle {
        property alias tbActive: root.active

        id: root
        property bool active: false
        signal toggled()
        width: box.width-3
        height: 44
        radius: root.height/3
        color: active ? "lightgrey" : "white"
        border.width: 1
        Text { id: text; anchors.centerIn: parent;
                font.pixelSize: parent.height * .6
                text: active ? "ON": "OFF"
         }
        MouseArea {
            anchors.fill: parent
            onClicked: { active = !active; root.toggled() }
        }
    }
