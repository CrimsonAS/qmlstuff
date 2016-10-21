import QtQuick 2.0

Rectangle {

    id: root

    width: 500
    height: 400

    color: "white"

    Rectangle {
        x: 50;
        y: 50
        width: 20
        height: 20

        color: "steelblue"

        NumberAnimation on rotation { from: 0; to: 360; duration: 5000; loops: -1 }
    }

    ShaderEffectSource {
        id: shaderSource
        sourceItem: root

        width: root.width * 0.7
        height: root.height * 0.7

        anchors.bottom: parent.bottom
        anchors.right: parent.right

        recursive: true
    }

    ShaderEffect {
        anchors.fill: shaderSource
        property variant source: shaderSource

        fragmentShader:
            "
            uniform lowp sampler2D source;
            varying highp vec2 qt_TexCoord0;
            void main() {
                gl_FragColor = mix(vec4(0, 0, 0, 1), texture2D(source, qt_TexCoord0).bgra, 0.9);
            }
            "
    }

}
