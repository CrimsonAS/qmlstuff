import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle
{
    id: root
    width: 320
    height: 480
    color: "black"

    property bool funky: true;

    MouseArea {
        anchors.fill: root;
        onClicked: root.funky = !root.funky
    }

    Item {
        id: effectRoot
        anchors.fill: parent

        Rectangle {

        }

        ParticleSystem {
            id: sys
            running: true;
        }

        ImageParticle{
            system: sys
            id: cp
            source: "particle.png"
            color: "#00b0d0FF"
            colorVariation: root.funky ? 0.3 : 0.05
        }

        Emitter{
            anchors.fill: parent
            system: sys
            velocityFromMovement: 4.0
            enabled: true
            emitRate: root.width / 50
            lifeSpan: 5000
            acceleration: AngleDirection{ angle: 90; angleVariation: root.funky ? 0 : 360; magnitude: 30; }
            velocity: AngleDirection{ angle: 90; angleVariation: root.funky ? 10 : 360; magnitude: 30; }
            size: 20
            sizeVariation: 4
        }

        visible: false
    }

    ShaderEffectSource {
        id: freshSource
        sourceItem: effectRoot
    }

    ShaderEffectSource {
        id: fadeSource
        sourceItem: shaderEffect
        recursive: true;
    }

    ShaderEffect {
        anchors.fill: parent
        id: shaderEffect
        property variant current: freshSource
        property variant last: fadeSource

        property real fallOff: root.funky ? 1/256. : 0;

        fragmentShader: "
            varying mediump vec2 qt_TexCoord0;
            uniform sampler2D current;
            uniform sampler2D last;
            uniform lowp float fallOff;
            void main() {
                highp vec4 s = texture2D(current, qt_TexCoord0);
                gl_FragColor = mix(texture2D(last, qt_TexCoord0) - fallOff, s, max(s.g, max(s.b, s.a)));
            }
        "
    }



}
