import QtQuick 2.5

Rectangle {
    id: root
    property int fakeCancelCount
    property int realCancelCount
    property int pressCount
    property int realReleaseCount
    property int fakeReleaseCount
    property int updateCount
    property var currentlyPressed

    function reset() {
        fakeCancelCount = 0
        realCancelCount = 0
        pressCount = 0
        realReleaseCount = 0
        fakeReleaseCount = 0
        updateCount = 0
        currentlyPressed = []
        pressModel.clear()
    }

    function debug(obj) {
        console.log(obj.text)

        obj.text = obj.text + " " + JSON.stringify(root.currentlyPressed)
        pressModel.append(obj)
    }

    function genColor(id) {
        return Qt.hsla((id % 100) / 100, 0.5, 0.5)
    }

    Component.onCompleted: {
        reset()
    }

    ListView {
        property bool dirty: false
        height: parent.height * 0.8
        width: 300
        model: ListModel {
            id: pressModel
        }
        delegate:
        Rectangle {
            width: childrenRect.width; height: childrenRect.height
            color: root.genColor(model.point)
            Text {
                text: model.text
            }
        }

        onCountChanged: dirty = true

        Timer {
            interval: 200
            running: true
            repeat: true
            onTriggered: {
                if (parent.dirty) parent.positionViewAtEnd()
                parent.dirty = false
            }
        }
    }

    Column {
        anchors.right: parent.right
        Text { text: "Presses: " + pressCount }
        Text { text: "Active Presses: " + (pressCount - (realCancelCount + fakeCancelCount + realReleaseCount + fakeReleaseCount)) }
        Item { // spacer
            height: 30
            width: 1
        }
        Text { text: "Cancels: " + realCancelCount }
        Text { text: "Fake Cancels: " + fakeCancelCount }
        Text { text: "Total Cancels: " + (realCancelCount + fakeCancelCount) }
        Item { // spacer
            height: 30
            width: 1
        }
        Text { text: "Releases: " + realReleaseCount }
        Text { text: "Fake Releases: " + fakeReleaseCount }
        Text { text: "Total Releases: " + (realReleaseCount + fakeReleaseCount) }
        Item { // spacer
            height: 30
            width: 1
        }
        Text { text: "Updates: " + updateCount }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        z: -1
        touchPoints: [
            TouchPoint { id: point1 },
            TouchPoint { id: point2 },
            TouchPoint { id: point3 },
            TouchPoint { id: point4 },
            TouchPoint { id: point5 },
            TouchPoint { id: point6 },
            TouchPoint { id: point7 },
            TouchPoint { id: point8 },
            TouchPoint { id: point9 },
            TouchPoint { id: point10 }
        ]

        onPressed: {
            pressCount += touchPoints.length
            for (var i = 0; i < touchPoints.length; ++i) {
                var p = touchPoints[i].pointId
                root.currentlyPressed.push(p)
                root.debug({text: "Pressed " + p, point: p })
            }
        }

        function doDebugOnPointsGone() {
            if (fakeCancelCount + realCancelCount + realReleaseCount + fakeReleaseCount == pressCount) {
                // Check everything is released
                var pts = root.currentlyPressed
                if (pts > 0) {
                    for (var i = 0; i < root.currentlyPressed.length; ++i) {
                        root.debug({text: "NO RELEASE FOR " + root.currentlyPressed[i], point: root.currentlyPressed[i] })
                    }
                    root.currentlyPressed = []
                }
            }
        }

        onCanceled: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var p = touchPoints[i].pointId

                var idx = root.currentlyPressed.indexOf(p)
                if (idx != -1) {
                    root.currentlyPressed.splice(idx, 1)
                    realCancelCount++
                    root.debug({text: "Cancelled " + p, point: p })
                } else {
                    fakeCancelCount++
                    root.debug({text: "*FAKE* CANCEL FOR " + p, point: p })
                }

            }

            doDebugOnPointsGone()
        }

        onReleased: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var p = touchPoints[i].pointId

                var idx = root.currentlyPressed.indexOf(p)
                if (idx != -1) {
                    root.currentlyPressed.splice(idx, 1)
                    realReleaseCount++
                    root.debug({text: "Released " + p, point: p })
                } else {
                    fakeReleaseCount++
                    root.debug({text: "*FAKE* RELEASE FOR " + p, point: p })
                }
            }

            doDebugOnPointsGone()
        }
        onUpdated: {
            updateCount += touchPoints.length
            //for (var i = 0; i < touchPoints.length; ++i) {
                //	root.debug({text: "Updated " + touchPoints[i].pointId, point: touchPoints[i].pointId })
                //}
            }
        }

        Rectangle {
            property var point: point1
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }
        Rectangle {
            property var point: point2
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point3
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point4
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point5
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point6
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point7
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point8
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point9
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }

        Rectangle {
            property var point: point10
            width: 120; height: 120; color: root.genColor(point.pointId); x: point.x - (width / 2); y: point.y - (height / 2); visible: point.pressed
        }



        Rectangle {
            color: "purple"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 100
            height: 100

            Text {
                anchors.centerIn: parent
                text: "Clear Data"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.reset()
                }
            }
        }
    }


