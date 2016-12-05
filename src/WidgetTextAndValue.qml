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

    property alias itemText : itemText.text
    property alias valueText : valueText.text
    property alias itemTextColor: itemText.color
    property alias valueTextColor: valueText.color
    property alias itemTextBold: itemText.font.bold
    property alias valueTextBold: valueText.font.bold

    states:[
            State{
                name:"NORMAL"
                PropertyChanges{ target: widget; color:"white"; itemTextColor:"black"; valueTextColor:"black"; itemTextBold:false; valueTextBold:false }
            },
            State{
                name:"INVERTED"
                PropertyChanges{ target: widget; color:"black"; itemTextColor:"white"; valueTextColor:"white"; itemTextBold:true; valueTextBold:true }
            }
        ]

    Text {
        id: valueText
        anchors {
            right: parent.right; verticalCenter: parent.verticalCenter; verticalCenterOffset: -1
            rightMargin: 6; left: itemText.right
        }
        font.pixelSize: parent.height * .4
        text: "<value>"
        horizontalAlignment: Text.AlignRight 
        elide: Text.ElideRight
        color: "black"
        smooth: true 
        //font.bold: true
    }
    Text {
        id: itemText
        //font.bold: true; 
        font.pixelSize: parent.height * .4
        text: "<item>"
        color: "black"
        smooth: true
        anchors { left: parent.left; leftMargin: 6; verticalCenterOffset: -3; verticalCenter: parent.verticalCenter }
    }
}