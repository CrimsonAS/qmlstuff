import QtQuick 2.0

Rectangle {
    width: 200
    height: 200

    Rectangle {
        onWidthChanged: print(width);

        anchors.fill: label;
        color: "black"
        opacity: 0.1
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: "This is a layer"
        layer.enabled: false
        scale: 1
    }


}
