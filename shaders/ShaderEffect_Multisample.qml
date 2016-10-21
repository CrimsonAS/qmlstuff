import QtQuick 2.0

Item {
    width: 500
    height: 400

    Rectangle {
        color: "steelblue"
        width: 50
        height: 50

        Rectangle {
            width: 40
            height: 40
            rotation: 10

            border.color: "black"

            color: "palegreen"
            anchors.centerIn: parent
        }

        layer.enabled: true
        layer.smooth: false

        scale: 5

        anchors.centerIn: parent
    }


    Rectangle {
        width: 300
        height: 10

        rotation: 3

        anchors.horizontalCenter: parent.horizontalCenter
        y: 10

        color: "black"
    }

}
