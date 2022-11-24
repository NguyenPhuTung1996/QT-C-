import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1

Item {
    id: root
    width: 1920
    height: 1096
    function openApplication(url){
        parent.push(url)
    }
    
    property int focusArea:0        // value = 0: focus is on Widgets Area, value = 1: focus is on Applications Area
    property int widgetIndex: 1     // position of Widget Focus
    property int appIndex: 0        // position of Application Focus



   // Widgets Area
    ListView {
        id: lvWidget
        spacing: 10
        orientation: ListView.Horizontal
        width: 1920
        height: 570
        interactive: false
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
        
        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                // @disable-check M16
                ListElement { type: "map" }
                // @disable-check M16
                ListElement { type: "climate" }
                // @disable-check M16
                ListElement { type: "media" }
            }
            
            delegate: DropArea {
                id: delegateRootWidget
                width: 635; height: 570
                keys: ["widget"]
                
                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
                onExited: iconWidget.item.enabled = true
                onDropped: {
                    console.log(drop.source.visualIndex)
                }
                
                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 635; height: 570
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    
                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget
                        case "media": return mediaWidget
                        }
                    }
                    
                    Drag.active: iconWidget.item.drag.active
                    Drag.keys: "widget"
                    Drag.hotSpot.x: delegateRootWidget.width/2
                    Drag.hotSpot.y: delegateRootWidget.height/2
                    
                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: root
                            }
                            
                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }
        
        Component {
            id: mapWidget
            MapWidget{
                onClicked: {
                    openApplication("qrc:/App/Map/Map.qml")
                    root.focusArea = 0
                    root.widgetIndex = 0
                }
                focus: (root.focusArea === 0 && root.widgetIndex === 0)?true:false
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                onClicked: {
                    openApplication("qrc:/App/Climate.qml")
                    root.focusArea = 0
                    root.widgetIndex = 1
                }
                focus: (root.focusArea === 0 && root.widgetIndex === 1)?true:false
            }
        }
        Component {
            id: mediaWidget
            MediaWidget{
                onClicked: {
                    openApplication("qrc:/App/Media/Media.qml")
                    root.focusArea = 0
                    root.widgetIndex = 2
                }
                focus: (root.focusArea === 0 && root.widgetIndex === 2)?true:false
            }
        }
    }


    // Applications Area
    ListView {
        id: appListview
        x: 0
        y: 570
        width: 1920; height: 526
        orientation: ListView.Horizontal
        interactive: false
        spacing: 5

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: appsModel
            delegate: DropArea {
                id: delegateRoot
                width: 316; height: 526
                keys: "AppButton"

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex) // Drag Item to re-oder
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 316; height: 526
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton{
                        id: app
                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        drag.axis: Drag.XAxis
                        drag.target: parent

                        onClicked: openApplication(model.url)
                        onReleased: {
                            // Handle application model
                            var listIndex = []
                            for (var index = 0; index < visualModel.items.count;index++){
                                if (index !== icon.visualIndex)
                                    visualModel.items.get(index).focus = false
                                else
                                    visualModel.items.get(index).focus = true

                                // Pass data to C++
                                listIndex[index] = visualModel.items.get(index).model
                                appsModel.getApplication(index, listIndex[index].title, listIndex[index].url,
                                                         listIndex[index].iconPath)
                            }
                            xmlWrite.writeXMLFile()   // Write data to file

                            root.focusArea = 1
                            root.appIndex = icon.visualIndex
                        }
                        onPositionChanged:{
                            app.state = "Pressed"
                            root.focusArea = 1
                            root.appIndex = icon.visualIndex
                        }
                        focus: (root.focusArea === 1 && root.appIndex === icon.visualIndex) ? true : false
                    }



                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: appListview
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        // Scrollbar
        ScrollBar.horizontal: ScrollBar {
            policy: ScrollBar.AsNeeded
            anchors.bottom: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: appListview.count > 6? 10:0
        }
    }
}
