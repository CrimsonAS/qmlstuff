import QtQuick 2.0
import QtQuick.Window 2.0
import com.crimson.stbtext 1.0

Item {
    id: root;
    property int count: 100;
    property real t;
    NumberAnimation on t { from: 0; to: 1; duration: 2347; loops: Animation.Infinite }

    StbFont {
        id: openSansFont
        font: "OpenSans-Regular.ttf"
        size: 12 * Screen.devicePixelRatio
    }

    Repeater {
        id: repeater
        model: root.count
        StbText {
            x: Math.random() * root.width
            y: Math.random() * root.height
            text: Math.floor( root.t * 1000 ) / 1000;
            font: openSansFont
        }
    }
}
