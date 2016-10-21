import QtQuick 2.0

Rectangle {
    width: 320
    height: 480

    Text {
        id: text
        font.pixelSize: 20
        text: "Shaderz, baby!"

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100

        Rectangle {
            width: parent.height
            height: parent.width
            anchors.centerIn: parent
            opacity: 0.3
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(1, 0, 0); }
                GradientStop { position: 0.5; color: Qt.rgba(0, 1, 0); }
                GradientStop { position: 1; color: Qt.rgba(0, 0, 1); }
            }
            rotation: 90
        }
    }

    ShaderEffectSource {

        anchors.centerIn: parent
        anchors.verticalCenterOffset: 100

        id: source
        sourceItem: text;
        format: ShaderEffectSource.Alpha

        visible: true
        width: text.width
        height: text.height
    }

}
