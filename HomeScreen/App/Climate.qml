import QtQuick 2.0

Item {
    id: root
    width: 1920
    height: 1200-104

    property string tempDriver: climateModel.driver_temp <= 16.5 ? "LOW":"HIGH"
    property string tempPassenger: climateModel.passenger_temp <= 16.5 ? "LOW":"HIGH"
    Image {
        id: headerItem
        source: "qrc:/App/Media/Image/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Climate Settings")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
    Text {
            x: 250
            y: 135 +141
            width: 184
            text: "DRIVER"
            color: "white"
            font.pixelSize: 34
            horizontalAlignment: Text.AlignHCenter
        }
        Image {
            x:250
            y: (135+41)+141
            width: 184
            source: "qrc:/Img/HomeScreen/widget_climate_line.png"
        }
        Image {
            x: 313
            y:205+141
            width: 110
            height: 120
            source: "qrc:/Img/HomeScreen/widget_climate_arrow_seat.png"
        }
        Image {
            x: 287
            y:(205+34)+141
            width: 70
            height: 50
            source: climateModel.driver_wind_mode == 0 || climateModel.driver_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_01_n.png"

        }
        Image {
            x: 239
            y:(205+34+26)+141
            width: 70
            height: 50
            source: climateModel.driver_wind_mode == 1 || climateModel.driver_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_02_n.png"
        }
        Text {
            id: driver_temp
            x: 250
            y: (248 + 107)+141
            width: 184
            text: climateModel.driver_temp > 16.5 && climateModel.driver_temp < 31.5 ? climateModel.driver_temp + "°C" : root.tempDriver
            color: "white"
            font.pixelSize: 46
            horizontalAlignment: Text.AlignHCenter
        }

        //Passenger
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 250
            y: 135+141
            width: 184
            text: "PASSENGER"
            color: "white"
            font.pixelSize: 34
            horizontalAlignment: Text.AlignHCenter
        }
        Image {
            anchors.right: parent.right
            anchors.rightMargin: 250
            y: (135+41)+141
            width: 184
            source: "qrc:/Img/HomeScreen/widget_climate_line.png"
        }
        Image {
            anchors.right: parent.right
            anchors.rightMargin: 272
            y:205+141
            width: 110
            height: 120
            source: "qrc:/Img/HomeScreen/widget_climate_arrow_seat.png"
        }
        Image {
            anchors.right: parent.right
            anchors.rightMargin: 343
            y: (205+34)+141
            width: 70
            height: 50
            source: climateModel.passenger_wind_mode == 0 || climateModel.passenger_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_01_n.png"
        }
        Image {
            anchors.right: parent.right
            anchors.rightMargin: 368
            y: (205+34+26)+141
            width: 70
            height: 50
            source: climateModel.passenger_wind_mode == 1 || climateModel.passenger_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_02_n.png"
        }
        Text {
            id: passenger_temp
            anchors.right: parent.right
            anchors.rightMargin: 250
            y: (248 + 107)+141
            width: 184
            text: climateModel.passenger_temp > 16.5 && climateModel.passenger_temp < 31.5 ? climateModel.passenger_temp + "°C" : root.tempPassenger
            color: "white"
            font.pixelSize: 46
            horizontalAlignment: Text.AlignHCenter
        }
        //Wind level
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 248+141
            width: 290
            height: 100
            source: "qrc:/Img/HomeScreen/widget_climate_wind_level_bg.png"
        }
        Image {
            id: fan_level
            anchors.horizontalCenter: parent.horizontalCenter
            y: 248+141
            width: 290
            height: 100
            source: climateModel.fan_level < 10 ? "qrc:/Img/HomeScreen/widget_climate_wind_level_0"+ climateModel.fan_level+".png" : fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_"+climateModel.fan_level+".png"
        }
        Connections{
            target: climateModel
            onDataChanged: {
                //set data for fan level
                if (climateModel.fan_level < 1) {
                    fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_01.png"
                }
                else if (climateModel.fan_level < 10) {
                    fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_0"+climateModel.fan_level+".png"
                } else {
                    fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_"+climateModel.fan_level+".png"
                }
                //set data for driver temp
                if (climateModel.driver_temp == 16.5) {
                    driver_temp.text = "LOW"
                } else if (climateModel.driver_temp == 31.5) {
                    driver_temp.text = "HIGH"
                } else {
                    driver_temp.text = climateModel.driver_temp+"°C"
                }

                //set data for passenger temp
                if (climateModel.passenger_temp == 16.5) {
                    passenger_temp.text = "LOW"
                } else if (climateModel.passenger_temp == 31.5) {
                    passenger_temp.text = "HIGH"
                } else {
                    passenger_temp.text = climateModel.passenger_temp+"°C"
                }
            }
        }

        //Fan
        Image {
            id: fanIcon
            anchors.horizontalCenter: parent.horizontalCenter
            y: (248 + 107)+141
            width: 60
            height: 60
            source: "qrc:/Img/HomeScreen/widget_climate_ico_wind.png"
        }
        //Bottom
        Text {
            x:250
            y:(466 + 18)+141
            width: 172
            horizontalAlignment: Text.AlignHCenter
            text: "AUTO"
            color: !climateModel.auto_mode ? "white" : "gray"
            font.pixelSize: 46
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y:466+141
            width: 171
            horizontalAlignment: Text.AlignHCenter
            text: "OUTSIDE"
            color: "white"
            font.pixelSize: 26
        }
        Text {
            id: tempOutside
            anchors.horizontalCenter: parent.horizontalCenter
            y:(466 + 18 + 21)+141
            width: 171
            horizontalAlignment: Text.AlignHCenter
            text: "27.5°C"
            color: "white"
            font.pixelSize: 38
        }
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 250
            y:(466 + 18)+141
            width: 171
            horizontalAlignment: Text.AlignHCenter
            text: "SYNC"
            color: !climateModel.sync_mode ? "white" : "gray"
            font.pixelSize: 46
        }

        Image
        {
            source: "qrc:/Img/HomeScreen/widget_climate_line.png"
            width: 1920
            anchors.top: tempOutside.bottom
            anchors.topMargin: 30
        }

        Image
        {
            source: "qrc:/Img/HomeScreen/widget_climate_line.png"
            width: 1920
            anchors.top: fanIcon.bottom
            anchors.topMargin: 30
        }

        Image {
            y:(466 + 18)+141+116
            source: "qrc:/Img/Climate/ico_arrow_d_n.png"
            anchors.left: driver_temp.left
        }

        Image {
            y:(466 + 18)+141+116
            source: "qrc:/Img/Climate/ico_arrow_d_n.png"
            anchors.right: fanIcon.left
            anchors.rightMargin: 20
        }

        Image {
            y:(466 + 18)+141+116
            source: "qrc:/Img/Climate/ico_arrow_d_n.png"
            anchors.left: passenger_temp.left
        }

        Image {
            y:(466 + 18)+141+116
            source: "qrc:/Img/Climate/ico_arrow_u_n.png"
            anchors.right: driver_temp.left
        }

        Image {
            y:(466 + 18)+141+116
            source: "qrc:/Img/Climate/ico_arrow_u_n.png"
            anchors.left: fanIcon.right
            anchors.leftMargin: 20
        }

        Image {
            y:(466 + 18)+141+116
            source: "qrc:/Img/Climate/ico_arrow_u_n.png"
            anchors.right: passenger_temp.right
        }

}
