import QtQuick 2.0

Item {
    id: root
    width: 1920
    height: 1200-104
    Image {
        id: headerItem
        source: "qrc:/App/Media/Image/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Radio")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
}
