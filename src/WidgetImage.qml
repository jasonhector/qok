import QtQuick 1.0

Rectangle {
    id: widgetImage
    color: "white"
    //width: parent.width-2*10
    //height: 360
    //anchors.horizontalCenter: parent.horizontalCenter
    //border.color: 'black'//"white"
    //border.width:1
    //y:10

    property alias wCondition : weatherIcon.condition


    Image{
            property string condition: "<condition>"
            id: weatherIcon
            width: parent.width
            height: parent.height
            anchors {
            horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter;
            }
            fillMode: Image.PreserveAspectFit
            //source:"../assets/weather/daytime/mostlysunny.gif"  
            source:qokModel.getWeatherIcon(condition) 
        }
}