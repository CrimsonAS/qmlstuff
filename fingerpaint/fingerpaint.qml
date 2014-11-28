/*
 *
 * Copyright (c) 2014 Robin Burchell <robin.burchell@viroteck.net>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import QtQuick 2.0

Rectangle {
    width: 640
    height: 480
    color: "black"

    Canvas {
        id: myCanvas
        anchors.fill: parent
        property var lastPosById
        property var posById

        property var colors: [
            "#00BFFF",
            "#FF69B4",
            "#F0E68C",
            "#ADD8E6",
            "#FFA07A",
            "#9370DB",
            "#98FB98",
            "#DDA0DD",
            "#FF6347",
            "#40E0D0"

        ]

        onPaint: {
            var ctx = getContext('2d')
            if (lastPosById == undefined) {
                lastPosById = {}
                posById = {}
            }

            for (var id in lastPosById) {
                ctx.strokeStyle = colors[id % colors.length]
                ctx.beginPath()
                ctx.moveTo(lastPosById[id].x, lastPosById[id].y)
                ctx.lineTo(posById[id].x, posById[id].y)
                ctx.stroke()

                // update lastpos
                lastPosById[id] = posById[id]
            }
        }

       MultiPointTouchArea {
           anchors.fill: parent

           onPressed: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i]
                    // update both so we have data
                    myCanvas.lastPosById[point.pointId] = {
                        x: point.x,
                        y: point.y
                    }
                    myCanvas.posById[point.pointId] = {
                        x: point.x,
                        y: point.y
                    }
                }
           }
           onUpdated: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i]
                    // only update current pos, last update set on paint
                    myCanvas.posById[point.pointId] = {
                        x: point.x,
                        y: point.y
                    }
                }
               myCanvas.requestPaint()
           }
           onReleased: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i]
                    delete myCanvas.lastPosById[point.pointId]
                    delete myCanvas.posById[point.pointId]
                }
           }
       }
    }

}
