import QtQuick 2.0

Item {
    width: 600
    height: 400

    Image {
        id: image
        source: "blackwhite2x1.png"
        visible: false
    }

    ShaderEffect {
        anchors.fill: parent
        anchors.margins: 10

        property variant source: image;


    }
}
