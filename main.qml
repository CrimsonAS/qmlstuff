import QtQuick 2.0

Item {
    width: 320
    height: 480

    Image {
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop

        anchors.fill: parent
        source: "wallpaper.jpg"

        NumberAnimation on rotation {
            id: rAnim
            from: 0
            to: 360
            duration: 5000
            loops: Animation.Infinite
        }
    }

    FPSMonitor {
    }
}
