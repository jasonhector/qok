import QtQuick 1.0

Rectangle {
    id: widgetValue
    color: "white"
    //width: parent.width-2*10
    //height: 360
    
    border.color: "black"
    border.width:1

    //y:10
    property alias valueText : valueText.text
	property alias valueTextFontPixelSize : valueText.font.pixelSize
    property alias widgetValueAnchors : widgetValue.anchors

    Text {
        id: valueText
        //anchors.fill: parent.fill
        anchors.horizontalCenter: parent.horizontalCenter 
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: parent.height// * .8
        text: "<value>"
        //horizontalAlignment: Text.AlignRight 
        //elide: Text.ElideRight
        color: "black"
        smooth: true 
        //font.bold: true
    }
}
