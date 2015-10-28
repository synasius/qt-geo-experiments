import QtQuick 2.5
import QtQuick.Controls 1.4

import QtLocation 5.5
import QtPositioning 5.5

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 600
    title: qsTr("Map overview")

    property var magione: QtPositioning.coordinate(43.142720, 12.205383)

    Plugin {
        id: somePlugin
        name: "mapbox"

        PluginParameter { name: "mapbox.map_id"; value: "mapbox.satellite" }
        PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1Ijoic3luYXNpdXMiLCJhIjoiY2lnM3JrdmRjMjJ4b3RqbTNhZ2hmYzlkbyJ9.EA86y0wrXX1eo64lJPTepw" }

        //Component.onCompleted: {
        //    console.debug("supports geocoding", supportsGeocoding());
        //    console.debug("supports mapping", supportsMapping());
        //    console.debug("supports places", supportsPlaces());
        //    console.debug("supports routing", supportsRouting());
        //}
    }

    Plugin {
        id: otherPlugin
        name: "osm"

        //Component.onCompleted: {
        //    console.debug("supports geocoding", supportsGeocoding());
        //    console.debug("supports mapping", supportsMapping());
        //    console.debug("supports places", supportsPlaces());
        //    console.debug("supports routing", supportsRouting());
        //}
    }

    RouteModel {
        id: routeModel
        plugin: otherPlugin

        query: RouteQuery {}

        Component.onCompleted: {
            query.addWaypoint(QtPositioning.coordinate(43.141126, 12.203845));
            query.addWaypoint(QtPositioning.coordinate(43.138679, 12.205133));
            query.addWaypoint(QtPositioning.coordinate(43.138014, 12.210712));
            routeModel.update();
        }

        onStatusChanged: console.debug("current route model status", status, count, errorString)
    }

    PlaceSearchModel {
        id: searchModel

        plugin: otherPlugin

        searchTerm: "food"
        searchArea: QtPositioning.circle(map.center, 10000)

        Component.onCompleted: update()

        onStatusChanged: console.debug("current search model status", status, count, errorString())
    }

    PositionSource {
        id: src
        updateInterval: 1000
        active: true

        onPositionChanged: {
            var coord = src.position.coordinate;
            console.debug("current position:", coord.latitude, coord.longitude);
        }
    }

    Map {
        id: map

        anchors.fill: parent
        plugin: otherPlugin

        center: magione
        gesture.enabled: true
        zoomLevel: 16

        MapItemView {
            model: searchModel
            delegate: MapCircle {
                center: model.place.location.coordinate

                radius: 50
                color: "#aa449944"
                border.width: 0
            }
        }

        MapItemView {
            model: routeModel
            delegate: MapRoute {
                route: routeData
                line.color: "blue"
                line.width: 5
                smooth: true
            }
        }

        MapCircle {
            id: currentPosition

            center: src.position.coordinate
            radius: 50
            color: "red"
            border.width: 0
        }
    }
}

