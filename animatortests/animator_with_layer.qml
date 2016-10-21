import QtQuick 2.4

Item {
    width: 320
    height: 480

    Image {
        anchors.centerIn: parent
        sourceSize.width: 200
        source: "/home/gunnar/Pictures/landscape_small.jpg"

        layer.enabled: true

        OpacityAnimator on opacity { from: 0; to: 1; duration: 1099; loops: Animation.Infinite }

        onOpacityChanged: print("opacity was changed: " + opacity)
    }
}