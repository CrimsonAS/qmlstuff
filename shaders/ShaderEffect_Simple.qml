import QtQuick 2.0

ShaderEffect {
    width: 180
    height: 180

    fragmentShader: "

varying highp vec2 qt_TexCoord0;

void main()
{
    gl_FragColor = vec4(0, qt_TexCoord0.xy, 1);
}
"

}
