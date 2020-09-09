import QtQuick 2.0

Item {
    width: 1920
    height: 1080

    Image {
        id: root
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.centerIn: parent

        Component.onCompleted: {
            height = parent.height
            width = parent.width
        }

        source: "wallpaper.jpg"

        SequentialAnimation {
            running: true
            loops: Animation.Infinite

            NumberAnimation {
                target: root
                property: "scale"
                from: 0.5
                to: 4.0
                duration: 3000
            }

            NumberAnimation {
                target: root
                property: "scale"
                from: 4.0
                to: 0.5
                duration: 1000
            }
        }
        NumberAnimation on rotation {
            id: rAnim
            from: 0
            to: 360
            duration: 5000
            loops: Animation.Infinite
        }
    }

    FPSMonitor {
        anchors.top: parent.top
        anchors.left: parent.left
    }
}
