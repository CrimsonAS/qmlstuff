import QtQuick 2.0
import QtQuick.Window 2.0
import com.crimson.stbtext 1.0

Item {
    id: root;
    property int count: 50;

    property real t;
    NumberAnimation on t { from: 0; to: 1; duration: 1000; loops: Animation.Infinite }
    onTChanged: {
        repeater.model = 0;
        repeater.model = root.count
    }

    Component.onCompleted: repeater.model = root.count

    StbFont {
        id: openSansFont
        font: "OpenSans-Regular.ttf"
        size: 12 * Screen.devicePixelRatio
    }

    Repeater {
        id: repeater
        StbText {
            x: Math.random() * (root.width - width)
            y: Math.random() * (root.height - height)
            text: "Qt Quick!"
            font: openSansFont
        }
    }
}
