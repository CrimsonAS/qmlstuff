import QtQuick 2.0
import QtQuick.Window 2.0
import com.crimson.stbtext 1.0

Item {
    id: root;
    property int count: 100

    property real t;
    NumberAnimation on t { from: 0; to: 1000; duration: 1000; loops: Animation.Infinite }

    StbFont {
        id: openSansFont
        font: "OpenSans-Regular.ttf"
        size: 15 * Screen.devicePixelRatio
    }

    Grid {
        anchors.fill: parent
        columns: root.width / 100
        spacing: 1
        Repeater {
            id: repeater
            model: root.count
            Rectangle {
                width: 100
                height: 20
                color: "steelblue"
                radius: 4
                    StbText { x: 0; text: "1"; color: "red"; font: openSansFont }
                    StbText { x: 10; text: "2"; color: "blue"; font: openSansFont }
                    StbText { x: 20; text: "3"; color: "lightsteelblue"; font: openSansFont }
                    StbText { x: 30; text: "-"; color: "white"; font: openSansFont }
                    StbText { x: 40; text: index == count - 1 ? Math.round( t ) : "[]"; font: openSansFont }
            }
        }
    }
}
