import QtQuick 1.0

Rectangle {
    id: widgetWind
    color: "white"
    width: parent.width
    //height: 360
    //anchors.horizontalCenter: parent.horizontalCenter
    border.color: "black"
    border.width:1
    //y:10

    property alias speedText : speedText.text
    property alias maxText : maxText.text
    property alias directionText : directionText.text

    Rectangle{
       id: info
        width: parent.width/2
        height: parent.height/3.5//44
        anchors { 
                    top: parent.top; left: parent.left
                 }
                 CustomBorder{
                    commonBorder: false; 
                    lBorderWidth:1; 
                    rBorderWidth:0;
                    tBorderWidth:1;
                    bBorderWidth:0}
        // /text:"Wind"
        Text{
            id:infoText
            anchors { centerIn: parent}
            font.pixelSize: parent.height* 0.8
            text:"Wind"
            color: "black"
            smooth: true 
        }
    }
    Rectangle{
       id: max
        width: parent.width/2
        height: parent.height/3.5//44
        anchors { 
                    top: parent.top; left: info.right 
                 }
                 CustomBorder{
                    commonBorder: false; 
                    lBorderWidth:0; 
                    rBorderWidth:1;
                    tBorderWidth:1;
                    bBorderWidth:0}
        Text{
           id:maxText
            anchors { centerIn: parent}
            font.pixelSize: parent.height* 0.7
            text:"<>"
            color: "black"
            smooth: true  
        }
    }

    Rectangle {
        id: direction
        width: parent.width
        height: (parent.height-max.height)/2
        anchors { horizontalCenter: parent.horizontalCenter
                    top: max.bottom; 
                 }
        CustomBorder{
                    commonBorder: false; 
                    lBorderWidth:1; 
                    rBorderWidth:1;
                    tBorderWidth:0;
                    bBorderWidth:0}
        Text{
            id:directionText
            anchors { centerIn: parent}
            font.pixelSize: parent.height* 0.9
            text:"<>"
            color: "black"
            smooth: true 
            }
        }


    Rectangle {
        id: speed
        width: parent.width
        height: (parent.height-max.height)/2
        anchors { horizontalCenter: parent.horizontalCenter
                    top: direction.bottom; 
                 }
        CustomBorder{
                    commonBorder: false; 
                    lBorderWidth:1; 
                    rBorderWidth:1;
                    tBorderWidth:0;
                    bBorderWidth:1}
        Text{
            id:speedText
            anchors { centerIn: parent}
            font.pixelSize: parent.height* 0.9
            text:"<>"
            color: "black"
            smooth: true 
            }
        }
    }
