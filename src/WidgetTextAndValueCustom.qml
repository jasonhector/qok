import QtQuick 1.0

Rectangle {
    id: widgetTextAndValueCustom
    color: "white"
    //width: parent.width-2*10
    //height: 360
    //anchors.horizontalCenter: parent.horizontalCenter
    border.color: "black"
    border.width:1
    //y:10

    property real ratio:0.2

    property alias itemText : itemText.text
    property alias valueText : valueText.text

    Text {
        id: itemText
        //font.bold: true; 
        font.pixelSize: parent.height * widgetTextAndValueCustom.ratio *0.8
        text: "<item>"
        color: "black"; smooth: true
        anchors {
                  horizontalCenter: parent.horizontalCenter;
                  top: parent.top; 
         }
    }

    Text {
        id: valueText
        anchors {
             top: itemText.bottom;
             horizontalCenter: parent.horizontalCenter;
        }
        font.pixelSize: parent.height * (1-widgetTextAndValueCustom.ratio)*0.8
        text: "<value>"
        //horizontalAlignment: Text.AlignRight 
        //elide: Text.ElideRight
        color: "black"
        smooth: true 
        //font.bold: true
    }

}