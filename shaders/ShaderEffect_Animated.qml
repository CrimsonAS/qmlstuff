import QtQuick 2.0

ShaderEffect
{
    width: 800
    height: 800

    property real t: 0;
    NumberAnimation on t { from: 0; to: Math.PI * 2; duration: 100000; loops: Animation.Infinite }

    property variant p1: Qt.point(
                             (Math.sin(t * 17 + 6) + Math.sin(t * 13 + 5) + Math.sin(t * 11 + 4)) / 6 + 0.5,
                             (Math.sin(t * 21 + 3) + Math.sin(t * 19 + 4) + Math.sin(t * 7 + 2)) / 6 + 0.5
                             );

    property variant p2: Qt.point(
                             (Math.sin(t * 21 + 2) + Math.sin(t * 19 + 7) + Math.sin(t * 7 + 15)) / 6 + 0.5,
                             (Math.sin(t * 17 + 31) + Math.sin(t * 13 + 47) + Math.sin(t * 11 + 21)) / 6 + 0.5
                             );

    property variant p3: Qt.point(
                             (Math.sin(t * 14 + 11) + Math.sin(t * 15 + 17) + Math.sin(t * 8 + 27)) / 6 + 0.5,
                             (Math.sin(t * 10 + 31) + Math.sin(t * 13 + 47) + Math.sin(t * 11 + 121)) / 6 + 0.5
                             );

    fragmentShader: "
        uniform lowp vec2 p1;
        uniform lowp vec2 p2;
        uniform lowp vec2 p3;
        varying highp vec2 qt_TexCoord0;

        lowp float cap(lowp float v) { return smoothstep(0.20, 0.205, v); }

        void main() {

            mediump float c1 = max(0.0, 0.5 - length(qt_TexCoord0 - p1));
            mediump float c2 = max(0.0, 0.5 - length(qt_TexCoord0 - p2));
            mediump float c3 = max(0.0, 0.5 - length(qt_TexCoord0 - p3));

            mediump float mix = cap(c1 * c1 + c2 * c2 + c3 * c3);

            gl_FragColor = vec4(mix * c1 * 2.0, mix * c2 * 2.0, mix * c3 * 2.0, 1);
        }
    "

}
