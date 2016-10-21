import QtQuick 2.4

Item
{
    id: root

    width: 320
    height: 480

    Rectangle
    {
        id: box

        width: 100
        height: 100

        anchors.centerIn: parent

        onXChanged: print("X is now: " + x);

        color: "lightsteelblue"

    }

    XAnimator { id: animator; target: box; from: 0; to: 220; duration: 10000; running: true }

    Timer {
        interval: 2000
        repeat: false
        running: true
        onTriggered: {
            animator.destroy();
        }
    }
}