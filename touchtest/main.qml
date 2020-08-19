import QtQuick 2.5

Canvas {
    id: root
    width: 900
    height: 900

    property int fakeCancelCount
    property int realCancelCount
    property int pressCount
    property int realReleaseCount
    property int fakeReleaseCount
    property int updateCount
    property var currentlyPressed
    property var lines
    property int lineCount
    property int mousePressCount
    property int mouseReleaseCount
    property int mouseClickedCount
    property int mouseMovedCount

    onPaint: {
        root.lineCount = lines.length

        var ctx = getContext("2d");
        ctx.lineWidth = 5
        ctx.lineCap = "round"
        ctx.fillStyle = "white"
        ctx.fillRect(0,  0,  width,  height);
        ctx.fill()

        for (var i = 0; i < lines.length; ++i) {
            var line = lines[i]
            ctx.strokeStyle = line.color

            ctx.beginPath()
            ctx.moveTo(line.points[0].x, line.points[0].y)
            for (var j = 1; j < line.points.length; ++j) {
                ctx.lineTo(line.points[j].x, line.points[j].y)
            }
            ctx.stroke()

            // draw circle at start and end
            ctx.beginPath();
            ctx.arc(line.points[0].x, line.points[0].y, 5, 0, 2 * Math.PI * 2, false);
            ctx.fillStyle = line.color
            ctx.fill()

            ctx.beginPath();
            ctx.arc(line.points[line.points.length - 1].x, line.points[line.points.length - 1].y, 5, 0, 2 * Math.PI * 2, false);
            ctx.fillStyle = line.color
            ctx.fill()
        }
    }

    function reset() {
        fakeCancelCount = 0
        realCancelCount = 0
        pressCount = 0
        realReleaseCount = 0
        fakeReleaseCount = 0
        updateCount = 0
        currentlyPressed = []
        mousePressCount = 0
        mouseReleaseCount = 0
        mouseClickedCount = 0
        mouseMovedCount = 0
        lines = []
        pressModel.clear()
        root.requestPaint()
    }

    function debug(obj) {
        console.log(obj.text)

        obj.text = obj.text + " " + JSON.stringify(root.currentlyPressed)

        // ListModel doesn't like objects of different types being placed into it.
        // To work around that, we do a JSON round trip dance to remove the existing type.
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
                if (parent.dirty) {
                    parent.positionViewAtEnd()
                    parent.dirty = false
                }

                var time = (new Date).getTime()

                for (var i = 0; i < lines.length; ++i) {
                    var line = lines[i]
                    if (line.active == false) {
                        if (time - line.lastPress > 5000) {
                            lines.splice(i, 1)
                            i--
                            root.requestPaint()
                        }
                    }
                }
            }
        }
    }

    Column {
        anchors.right: parent.right
        Text { text: "Presses: " + pressCount }
        Text { text: "Active Presses: " + (pressCount - (realCancelCount + fakeCancelCount + realReleaseCount + fakeReleaseCount)) }
        Text { text: "Active Strokes: " + root.lineCount }
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

        Item { // spacer
            height: 30
            width: 1
        }
        Text { text: "Mouse press: " + mousePressCount }
        Text { text: "Mouse release: " + mouseReleaseCount }
        Text { text: "Mouse click: " + mouseClickedCount }
        Text { text: "Mouse moved: " + mouseMovedCount }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPressed: {
            var idx = root.currentlyPressed.indexOf(-1)
            if (idx != -1) {
                console.warn("PRESSED BEFORE RELEASE SEEN!");
                return;
            }

            mousePressCount++
	    root.debug({text: "Mouse pressed", x: mouseX, y: mouseY, point: -1 } )
            root.currentlyPressed.push(-1);

            var t = (new Date).getTime()
            lines.push({
                active: true,
                point: -1 /* mouse */,
                color: genColor(-1),
                lastPress: t,
                startPress: t,
                points: [ { x: mouseX, y: mouseY } ]
            })
            root.requestPaint()
        }
        onReleased: {
            var idx = root.currentlyPressed.indexOf(-1)
            if (idx != -1) {
                mouseReleaseCount++
                root.currentlyPressed.splice(idx, 1)
                var t = (new Date).getTime()
                var sp = 0

                for (var j = 0; j < lines.length; ++j) {
                    var line = lines[j]
                    if (line.point == -1 && line.active) {
                        sp = line.startPress
                        line.active = false
                        line.lastPress = t
                        line.points.push({ x: mouseX, y: mouseY })
                        root.requestPaint()
                        break;
                    }
                }

                root.debug({text: "Mouse released -- held for " + (t - sp) + " ms", x: mouseX, y: mouseY, point: -1 })
            } else {
                fakeReleaseCount++
                root.debug({text: "*FAKE* MOUSE RELEASE", x: mouseX, y: mouseY, point: -1 })
            }
        }
        onClicked: {
            mouseClickedCount++
        }
        onPositionChanged: {
            mouseMovedCount++
            for (var j = 0; j < lines.length; ++j) {
                var line = lines[j]
                if (line.point == -1 && line.active) {
                    root.debug({text: "Mouse moved " + Math.round(mouseX) + ":" + Math.round(mouseY), point: -1 })
                    line.lastPress = (new Date).getTime()
                    line.points.push({ x: mouseX, y: mouseY })
                    root.requestPaint()
                    break;
                }
            }
        }
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
                root.debug({text: "Pressed " + p, point: p, point: touchPoints[i].pointId })

                var t = (new Date).getTime()
                lines.push({
                    active: true,
                    point: p,
                    color: genColor(p),
                    lastPress: t,
                    startPress: t,
                    points: [ { x: touchPoints[i].sceneX, y: touchPoints[i].sceneY } ]
                })
                root.requestPaint()
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
                    var t = (new Date).getTime()
                    var sp = 0

                    for (var j = 0; j < lines.length; ++j) {
                        var line = lines[j]
                        if (line.point == p && line.active) {
                            sp = line.startPress
                            line.active = false
                            line.lastPress = t
                            line.points.push({ x: touchPoints[i].sceneX, y: touchPoints[i].sceneY })
                            root.requestPaint()
                            break;
                        }
                    }

                    root.debug({text: "Cancelled " + p + " -- held for " + (t - sp) + " ms", point: p })
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
                    var t = (new Date).getTime()
                    var sp = 0

                    for (var j = 0; j < lines.length; ++j) {
                        var line = lines[j]
                        if (line.point == p && line.active) {
                            sp = line.startPress
                            line.active = false
                            line.lastPress = t
                            line.points.push({ x: touchPoints[i].sceneX, y: touchPoints[i].sceneY })
                            root.requestPaint()
                            break;
                        }
                    }

                    root.debug({text: "Released " + p + " -- held for " + (t - sp) + " ms", point: p })
                } else {
                    fakeReleaseCount++
                    root.debug({text: "*FAKE* RELEASE FOR " + p, point: p })
                }
            }

            doDebugOnPointsGone()
        }
        onUpdated: {
            updateCount += touchPoints.length
            for (var i = 0; i < touchPoints.length; ++i) {
                    var p = touchPoints[i].pointId
                    for (var j = 0; j < lines.length; ++j) {
                        var line = lines[j]
                        if (line.point == p && line.active) {
                            line.lastPress = (new Date).getTime()
                            line.points.push({ x: touchPoints[i].sceneX, y: touchPoints[i].sceneY })
                            root.requestPaint()
                            break;
                        }
                    }
                //	root.debug({text: "Updated " + touchPoints[i].pointId, point: touchPoints[i].pointId })
            }
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

