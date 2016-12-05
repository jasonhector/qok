import QtQuick 1.0

Rectangle {
    id: widgetMinMaxCustom
    color: "white"
    width: parent.width
    //height: 360
    //anchors.horizontalCenter: parent.horizontalCenter
    border.color: "black"
    border.width:1
    //y:10

    property alias dayText : day.text
    property alias minText : min.text
    property alias maxText : max.text
    property alias wCondition : wImage.wCondition

    Row {
            id:rows
            spacing: 0
            height: parent.height
            width: parent.width
            
            Rectangle{
                id: dayAndCondition
                width: 2*rows.width/3
                height: parent.height
                //border.color: "black"
                //border.width:1
                CustomBorder{commonBorder: false; lBorderWidth:1; rBorderWidth:0;tBorderWidth:1;bBorderWidth:1}
                Text {
                    id: day
                    font.pixelSize: parent.height * 0.2
                    text: "<day>"
                    color: "black"; smooth: true
                    anchors { horizontalCenter: parent.horizontalCenter;
                              top: parent.top; 
                     }
                }
                WidgetImage {
                    id: wImage
                    //border.color:"white"
                    width: parent.width
                    height: parent.height*0.75
                    wCondition:'<condition>'
                    anchors { horizontalCenter: parent.horizontalCenter;
                              bottom: parent.bottom; 
                     }
                }
            }
            Rectangle{
                id: minMax
                width: rows.width/3
                height: parent.height
                //border.color: "black"
                //border.width:1
                CustomBorder{commonBorder: false; lBorderWidth:0; rBorderWidth:1;tBorderWidth:1;bBorderWidth:1}
                Text {
                    id: min
                    font.pixelSize: parent.height * .4
                    text: "<item>"
                    color: "black"; smooth: true
                    anchors { horizontalCenter: parent.horizontalCenter;
                              top: parent.top; 
                     }
                }
                Text {
                    id: max
                    anchors {
                         bottom: parent.bottom;
                         horizontalCenter: parent.horizontalCenter;
                    }
                    font.pixelSize: parent.height * .4
                    text: "<value>"
                    color: "black"
                    smooth: true 
                }
            }

        }

}