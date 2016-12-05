/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.0
//import "CalculatorCore"
//import "CalculatorCore/calculator.js" as CalcEngine

Rectangle {
    id: window

    //width: 360; height: 480
    width: 800; height: 600
    color: "white"

    property string rotateLeft: "\u2939"
    property string rotateRight: "\u2935"
    //property string leftArrow: "\u2190"
    //property string division : "\u00f7"
    //property string multiplication : "\u00d7"
    //property string squareRoot : "\u221a"
    //property string plusminus : "\u00b1"

    //Connect Signal from python to QML
    //eg. updates in model to reflect in ui

    property int counter:0

    function inits(){
        update1s()
        update60s()
    }

    function update1s(){
        //ALARM
        almArmed.valueText=qokModel.getItemValue('almArmed')
        windows.valueText=qokModel.getItemValue('Windows')
        doors.valueText=qokModel.getItemValue('Doors')

        //ENERGY
        unitsNow.valueText=qokModel.getItemValue('unitsNow')
        ct1_realPower.valueText=qokModel.getItemValue('ct1_realPower')
        ct2_realPower.valueText=qokModel.getItemValue('ct2_realPower')
        ct4_realPower.valueText=qokModel.getItemValue('ct4_realPower')
        ct5_realPower.valueText=qokModel.getItemValue('ct5_realPower')

        //CONTROL
        bedlight.active=qokModel.getItemValue('m201_rly1')
        elecBlanket.active=qokModel.getItemValue('m201_rly2')
    }

    function update60s() {

        
        //refresh screen hack
        //if (window.counter==10){
        //    refresh.visible = true
        //    window.counter=0
        //}else{
        //    refresh.visible = false
        //}window.counter = window.counter+1
        
        //TIME AND DATE
        //time.itemText = Date().toString()
        time.valueText= Qt.formatTime(new Date(),"hh:mm")
        date.valueText= Qt.formatDate(new Date(),"d MMM yy")
        day.valueText= Qt.formatDate(new Date(),"dddd")
        //weatherImage.wCondition = qokModel.getItemValue('wCondition')

        //WEATHER FORECAST
        weatherMinMaxImage1.dayText = qokModel.getDaysAhead(1)
        weatherMinMaxImage2.dayText = qokModel.getDaysAhead(2)
        weatherMinMaxImage3.dayText = qokModel.getDaysAhead(3)
        weatherMinMaxImage4.dayText = qokModel.getDaysAhead(4)
        weatherMinMaxImage5.dayText = qokModel.getDaysAhead(5)
    

        //SUNRISE AND SUNSET
        sunriseTime.valueText=qokModel.getItemValue('sunriseTime')
        sunsetTime.valueText=qokModel.getItemValue('sunsetTime')

        //TEMP TODAY
        weatherMinMaxImage.wCondition=qokModel.getItemValue('wCondition')
        weatherMinMaxImage.minText =qokModel.getItemValue('tempMin0')
        weatherMinMaxImage.maxText=qokModel.getItemValue('tempMax0')
        
        //WEATHER FORECAST 5 DAY
        weatherMinMaxImage1.wCondition=qokModel.getItemValue('wCondition1')
        weatherMinMaxImage1.minText=qokModel.getItemValue('tempMin1')
        weatherMinMaxImage1.maxText=qokModel.getItemValue('tempMax1')
        
        weatherMinMaxImage2.wCondition=qokModel.getItemValue('wCondition2')
        weatherMinMaxImage2.minText=qokModel.getItemValue('tempMin2')
        weatherMinMaxImage2.maxText=qokModel.getItemValue('tempMax2')

        weatherMinMaxImage3.wCondition=qokModel.getItemValue('wCondition3')
        weatherMinMaxImage3.minText=qokModel.getItemValue('tempMin3')
        weatherMinMaxImage3.maxText=qokModel.getItemValue('tempMax3')

        weatherMinMaxImage4.wCondition=qokModel.getItemValue('wCondition4')
        weatherMinMaxImage4.minText=qokModel.getItemValue('tempMin4')
        weatherMinMaxImage4.maxText=qokModel.getItemValue('tempMax4')

        weatherMinMaxImage5.wCondition=qokModel.getItemValue('wCondition5')
        weatherMinMaxImage5.minText=qokModel.getItemValue('tempMin5')
        weatherMinMaxImage5.maxText=qokModel.getItemValue('tempMax5')
        
        //TEMP NOW AND PRECIPITATION
        tempCurrent.valueText=qokModel.getItemValue('tempCurrent')
        wPrecipitation.valueText=qokModel.getItemValue('wPrecipitation')
        
        //WIND
        wind.speedText=qokModel.getItemValue('wWindSpeed')
        wind.maxText=qokModel.getItemValue('wWindgust')
        wind.directionText=qokModel.getItemValue('wWindDirection')

    }// Console.print('rx from model via python')}

    Item {
        id: main
        state: "orientation "// + runtime.orientation

        property bool landscapeWindow: window.width < window.height 
        property real baseWidth: landscapeWindow ? window.height : window.width
        property real baseHeight: landscapeWindow ? window.width : window.height
        property real rotationDelta: landscapeWindow ? -90 : 0

        property int numUnits:12

        rotation: rotationDelta
        width: main.baseWidth
        height: main.baseHeight
        anchors.centerIn: parent
		
		Timer {
                interval: 60000; running: true; repeat: true
                onTriggered: update60s()
            }
        Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: update1s()
            }

        Timer {
            id: init
                interval: 100; running: true; repeat: false
                onTriggered: inits()
            }

        Column {
            id: box; 
            spacing: 0

            anchors { fill: parent; topMargin: 6; bottomMargin: 6; leftMargin: 6; rightMargin: 6 }

            //ALARM
            Row {
                    spacing: 0
                    height: box.height/main.numUnits

                    WidgetTextAndValue {
                        id: almArmed
                        width: box.width/4
                        height: parent.height//44
                        itemText:"Alarm:"
                        valueText: '<>'
                        onValueTextChanged:{ 
                                if (almArmed.valueText=='armed') almArmed.state='INVERTED'
                                else almArmed.state='NORMAL'
                        }
                    }
                    WidgetTextAndValue {
                        id: windows
                        width: 3*box.width/8
                        height: parent.height//44
                        itemText:"# Open Windows:"
                        valueText: '<>'
                    }
                    WidgetTextAndValue {
                        id: doors
                        width: 3*box.width/8
                        height: parent.height//44
                        itemText:"# Open Doors:"
                        valueText: '<>'
                    }
                }
            //TIME ROW
            Row{
                spacing: 0
                height: 3*box.height/main.numUnits

                Rectangle{
                    width: box.width/5
                    height: parent.height
                    border.color: "black"
                    border.width:1
                    WidgetTextAndValueCustom {
                        id: sunriseTime
                        width: parent.width
                        height: parent.height/2
                        anchors { horizontalCenter: parent.horizontalCenter;
                              top: parent.top
                        }
                        ratio:0.4
                        itemText:"Sunrise"
                        valueText: "<00h00>"
                    }
                    WidgetTextAndValueCustom {
                        id: sunsetTime
                        width: parent.width
                        height: parent.height/2
                        anchors { horizontalCenter: parent.horizontalCenter;
                              top:sunriseTime.bottom; bottom: parent.bottom
                        }
                        ratio:0.4
                        itemText:"Sunset"
                        valueText: "<00h00>"
                    }
                }

                WidgetValue {
                id: time
                width: 11*box.width/20
                height: parent.height
                valueText: Qt.formatTime(new Date(),"hh:mm")
                MouseArea {
                    anchors.fill: parent
                    onClicked: { qokModel.log('time.onClick event');updateAllItems() }
                    }
                }
                Rectangle{
                    width: box.width/4
                    height: parent.height
                    border.color: "black"
                    border.width:1
                    WidgetValue {
                        id: day
                        //width: box.width/2
                        height: parent.height/4
                        anchors { horizontalCenter: parent.horizontalCenter;
                              top: parent.top; 
                        }
                        valueText: Qt.formatDate(new Date(),"dddd")
                        
                    }
                    WidgetValue {
                        id: date
                        //width: box.width/2
                        height: parent.height/4
                        anchors { horizontalCenter: parent.horizontalCenter;
                              top: day.bottom;  
                        }
                        valueText: Qt.formatDate(new Date(),"d MMM yy")
                    }
                    WidgetTextAndValueCustom {
                        id: unitsNow
                        width: parent.width
                        height: parent.height/2
                        anchors { horizontalCenter: parent.horizontalCenter;
                              top: date.bottom;  bottom: parent.bottom
                        }
                        ratio:0.4
                        itemText:"Units Left"
                        valueText: "<00>"
                    }
                }
            }
            //ENERGY ROW
            Row{
                spacing: 0
                height: box.height/main.numUnits
                WidgetTextAndValue {
                                id: ct1_realPower
                                width: box.width/4
                                height: parent.height
                                itemText:"Tot Pwr"
                                valueText: '<>'
                                onValueTextChanged:{ 
                                if (parseInt(ct1_realPower.valueText.split('W')[0])>4000) ct1_realPower.state='INVERTED'
                                else ct1_realPower.state='NORMAL'
                                }
                }
                WidgetTextAndValue {
                                id: ct2_realPower
                                width: box.width/4
                                height: parent.height
                                itemText:"Fridges,Oven"
                                valueText: '<>'
                }
                WidgetTextAndValue {
                                id: ct4_realPower
                                width: box.width/4
                                height: parent.height
                                itemText:"Geyser"
                                valueText: '<>'
                                onValueTextChanged:{ 
                                if (parseInt(ct4_realPower.valueText.split('W')[0])>4000) ct4_realPower.state='INVERTED'
                                else ct4_realPower.state='NORMAL'
                                }
                }
                WidgetTextAndValue {
                                id: ct5_realPower
                                width: box.width/4
                                height: parent.height
                                itemText:"Pool, Irrig"
                                valueText: '<>'
                }
            }
            //WEATHER NOW ROW
            Row{
                spacing: 0
                height: 3*box.height/main.numUnits


                Rectangle{
                    width: box.width/4
                    height: parent.height
                    border.color: "black"
                    border.width:1
                    WidgetTextAndValueCustom {
                        id: wPrecipitation
                        width: parent.width
                        height: parent.height
                        ratio:0.4
                        itemText:"Rain"
                        valueText: "0%"
                        }
                }    
                
                

                WidgetValue {
                id: tempCurrent
                width: box.width/4
                height: parent.height
                valueText:'<>'
                }
                WidgetMinMaxCustom{
                    id: weatherMinMaxImage
                    width: box.width/4
                    //height: box.height/main.numUnits*2//144
                    height: parent.height
                    dayText:"Today"
                    wCondition:'Partly Cloudy'
                    minText:'10'
                    maxText:'20'
                }
                WidgetWind{
                    id: wind
                    width: box.width/4
                    height: parent.height
                    border.color: "black"
                    border.width:1
                    speedText:"34"
                    maxText:"35"
                    directionText:"SE"
                }


            }

            
           //WidgetImage {
           //         id: weatherImage
           //         width: box.width-3
           //         height: parent.height
           //         border.color: "black"
           //         border.width:1
           //         wCondition:'Partly Cloudy'
           //     } 




           //WEATHER FORECAST ROW
            Row {
                    spacing: 0
                    id:forecast
                    height:2*box.height/main.numUnits
                    WidgetMinMaxCustom{
                        id: weatherMinMaxImage1
                        width: box.width/5
                        //height: box.height/main.numUnits*2//144
                        height: parent.height
                        dayText:qokModel.getDaysAhead(1)
                        wCondition:'Partly Cloudy'
                        minText:'10'
                        maxText:'20'
                    }
                    WidgetMinMaxCustom{
                        id: weatherMinMaxImage2
                        width: box.width/5
                        //height: box.height/main.numUnits*2//144
                        height: parent.height
                        dayText:qokModel.getDaysAhead(2)
                        wCondition:'Partly Cloudy'
                        minText:'10'
                        maxText:'20'
                    }
                    WidgetMinMaxCustom{
                        id: weatherMinMaxImage3
                        width: box.width/5
                        //height: box.height/main.numUnits*2//144
                        height: parent.height
                        dayText:qokModel.getDaysAhead(3)
                        wCondition:'Partly Cloudy'
                        minText:'10'
                        maxText:'20'
                    }
                    WidgetMinMaxCustom{
                        id: weatherMinMaxImage4
                        width: box.width/5
                        //height: box.height/main.numUnits*2//144
                        height: parent.height
                        dayText:qokModel.getDaysAhead(4)
                        wCondition:'Partly Cloudy'
                        minText:'10'
                        maxText:'20'
                    }
                    WidgetMinMaxCustom{
                        id: weatherMinMaxImage5
                        width: box.width/5
                        //height: box.height/main.numUnits*2//144
                        height: parent.height
                        dayText:qokModel.getDaysAhead(5)
                        wCondition:'Partly Cloudy'
                        minText:'10'
                        maxText:'20'
                    }
            }
            
            
            //CONTROL ROW
            Row {
                id:control
                height:2*box.height/main.numUnits
                spacing: 0
                WidgetToggleButton {
                    id: bedlight
                    width: box.width/2
                    height: parent.height
                    itemText:"Bedlight"
                    onChange: qokModel.setItemValue('m201_rly1', bedlight.active)
                }
                WidgetToggleButton {
                    id: elecBlanket
                    width: box.width/2
                    height: parent.height
                    itemText:"Elec blanket"
                    onChange: qokModel.setItemValue('m201_rly2', elecBlanket.active)
                }
            }

            /*
            Column {
                id: column; spacing: 6

                property real h: ((box.height - 72) / 6) - ((spacing * (6 - 1)) / 6)
                property real w: (box.width / 4) - ((spacing * (4 - 1)) / 4)

                Row {
                    spacing: 6
                    Widget { width: column.w; height: column.h; itemText: "Bedside Light" }
                    Widget { width: column.w; height: column.h; itemText: "Elec blanket" }
                }
            }
            */
            
            
            //WidgetValue {
            //    id: wCondition
            //    width: box.width-3
            //    height: 44
            //    valueText:qokModel.getItemValue('wCondition')
            //    valueTextFontPixelSize: 44 * .8
            //}
            
            /*
            Row {
                    spacing: 0
                    id:forecasts
                    height:124

                    WidgetTextAndValueCustom {
                        id: tempMin0
                        width: box.width/4
                        height: forecast.height
                        itemText:"today min [°C]"
                        valueText: qokModel.getItemValue('tempMin0').split('.')[0]
                    }
                    WidgetTextAndValueCustom {
                        id: tempMax0
                        width: box.width/4
                        height: forecast.height
                        itemText:"today max [°C]"
                        valueText: qokModel.getItemValue('tempMax0').split('.')[0]
                    }
                    WidgetTextAndValueCustom {
                        id: tempMin1
                        width: box.width/4
                        height: forecast.height
                        itemText:"tomorrow min [°C]"
                        valueText: qokModel.getItemValue('tempMin1').split('.')[0]
                    }
                    WidgetTextAndValueCustom {
                        id: tempMax1
                        width: box.width/4
                        height: forecast.height
                        itemText:"tomorrow max [°C]"
                        valueText: qokModel.getItemValue('tempMax1').split('.')[0]
                    }
            }
            */
        }

        Rectangle{
            id:partial
            visible: false
            width: box.width+12
            height: 1
            color:"grey"
            y:504
        }

        Rectangle{
            id:full
            visible: false
            width: box.width+12
            height: 1
            color:"grey"
            y:600
        }

        Rectangle{
            id:refresh
            visible: false
            width: box.width+12
            height: box.height+12
            color:"white"
        }


        states: [
            State {
                name: "orientation " + Orientation.Landscape
                PropertyChanges { target: main; rotation: 90 + rotationDelta; width: main.baseHeight; height: main.baseWidth }
            },
            State {
                name: "orientation " + Orientation.PortraitInverted
                PropertyChanges { target: main; rotation: 180 + rotationDelta; }
            },
            State {
                name: "orientation " + Orientation.LandscapeInverted
                PropertyChanges { target: main; rotation: 270 + rotationDelta; width: main.baseHeight; height: main.baseWidth }
            }
        ]

        transitions: Transition {
            SequentialAnimation {
                RotationAnimation { direction: RotationAnimation.Shortest; duration: 300; easing.type: Easing.InOutQuint  }
                NumberAnimation { properties: "x,y,width,height"; duration: 300; easing.type: Easing.InOutQuint }
            }
        }
    }
}
