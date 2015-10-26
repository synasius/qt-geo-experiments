import QtQuick 2.5
import QtQuick.Controls 1.4

import QtLocation 5.5
import QtPositioning 5.5

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: qsTr("Map overview")

    Plugin {
        id: somePlugin
        name: "mapbox"

        PluginParameter { name: "mapbox.map_id"; value: "mapbox.emerald" }
        PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1Ijoic3luYXNpdXMiLCJhIjoiY2lnM3JrdmRjMjJ4b3RqbTNhZ2hmYzlkbyJ9.EA86y0wrXX1eo64lJPTepw" }

        Component.onCompleted: {
            console.debug("supports geocoding", supportsGeocoding());
            console.debug("supports mapping", supportsMapping());
            console.debug("supports places", supportsPlaces());
            console.debug("supports routing", supportsRouting());
        }
    }

    Plugin {
        id: otherPlugin
        name: "osm"

        Component.onCompleted: {
            console.debug("supports geocoding", supportsGeocoding());
            console.debug("supports mapping", supportsMapping());
            console.debug("supports places", supportsPlaces());
            console.debug("supports routing", supportsRouting());
        }
    }

    PlaceSearchModel {
        id: searchModel

        plugin: otherPlugin

        searchTerm: "food"
        searchArea: QtPositioning.circle(map.center, 10000)

        Component.onCompleted: update()

        onStatusChanged: console.debug("current status", status, count, errorString())
    }

    PositionSource {
        id: src
        updateInterval: 1000
        active: true

        onPositionChanged: {
            var coord = src.position.coordinate;
            console.log("Coordinate:", coord.longitude, coord.latitude);
        }
    }

    Row {
        anchors.fill: parent

        Map {
            id: map

            width: parent.width - 200; height: parent.height
            plugin: somePlugin

            center: src.position.coordinate
            gesture.enabled: true
            zoomLevel: 16

            MapItemView {
                model: searchModel
                delegate: MapCircle {
                    center: model.place.location.coordinate

                    radius: 50
                    color: "green"
                    border.width: 0
                }
            }

            MapCircle {
                id: currentPosition

                center: src.position.coordinate
                radius: 10
                color: "red"
                border.width: 0
            }
        }

        ListView {
            width: 200; height: parent.height
            model: searchModel
            delegate: Column {
                Text { text: title }
                Text { text: place.location.address.text }
            }
        }
    }
}

