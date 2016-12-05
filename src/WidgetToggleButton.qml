import QtQuick 1.0

Rectangle {
    id: widget
    color: "white"
    //width: parent.width-2*10
    //height: 360
    //anchors.horizontalCenter: parent.horizontalCenter
    border.color: "black"
    border.width:1
    //y:10
    signal change() 
    property alias itemText : itemText.text
    property alias active : tb.tbActive

    Text {
        id: itemText
        //font.bold: true; 
        font.pixelSize: parent.height * .4
        text: "<item>"
        color: "black"; smooth: true
        anchors { left: parent.left; leftMargin: 6; verticalCenterOffset: -3; verticalCenter: parent.verticalCenter }
    }
    ToggleButton{
        id: tb
        height: parent.height-10
        width : parent.width/3
        anchors{right:parent.right; verticalCenter: parent.verticalCenter; rightMargin:5}
        onToggled: change()
    }
}