import QtQuick 2.2

ShaderEffect {

    id: root

    width: 800
    height: 600

    property int iterations: 1;

    blending: false

    vertexShader: 
    "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;

        uniform highp mat4 qt_Matrix;

        varying highp vec2 tc;

        void main() {
            gl_Position = qt_Matrix * qt_Vertex;
            tc = qt_MultiTexCoord0 * 3.14152;
        }
    "

    fragmentShader: 
    "
        uniform int iterations;
        varying highp vec2 tc;
        void main ()
        {
            highp vec2 r = vec2(0);
            for (int i=0; i<iterations; ++i) {
                float c = float(i);
                r += abs(sin(tc * pow(2.0, c)));
            }
            gl_FragColor = vec4(r / float(iterations), 0, 1);
        }
    "


    Rectangle {
        x: 10
        y: 10
        width: 100
        height: 100
        property bool uhm: false
        color: uhm ? "red" : "blue"
        onFooChanged: uhm = !uhm;
        property real foo; NumberAnimation on foo { from: 0; to: 1; duration: 1000; loops: -1 }

        Text {
            font.pixelSize: 60
            color: "white"
            text: root.iterations
            anchors.centerIn: parent
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (mouse.y > height / 2) 
                ++root.iterations
            else 
                --root.iterations
            print("using: " + root.iterations + " iterations..");
        }

    }

}