import QtQuick 2.4

Item
{

    width: 320
    height: 480

    Rectangle
    {
        id: box

        width: 100
        height: 100

        x: 100
        y: 100

        onXChanged: print("X is now: " + x);
        onYChanged: print("Y is now: " + y);
        onOpacityChanged: print("Opacity is now: " + opacity);

        color: "lightsteelblue"

        SequentialAnimation {
            XAnimator { target: box; from: 100; to: 200; duration: 1000 }
            YAnimator { target: box; from: 100; to: 200; duration: 1000 }
            OpacityAnimator { target: box; from: 1; to: 0; duration: 1000 }
            loops: 1
            running: true
        }
    }
}