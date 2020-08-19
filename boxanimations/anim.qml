import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

Window {
    id: root
    title: "Demo"
    visible: true
    width: 1000
    height: 800

    Row {
        id: buttons
        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }
        spacing: 5

        Button {
            text: "More!"

            onClicked: {
                spinner.createObject(boxes, {
                    'color': randomColor()
                })
            }

            function randomColor() {
                var colors = "Pink LightPink HotPink DeepPink PaleVioletRed MediumVioletRed LightSalmon Salmon DarkSalmon LightCoral IndianRed Crimson FireBrick DarkRed Red OrangeRed Tomato Coral DarkOrange Orange Yellow LightYellow LemonChiffon LightGoldenrodYellow PapayaWhip Moccasin PeachPuff PaleGoldenrod Khaki DarkKhaki Gold Cornsilk BlanchedAlmond Bisque NavajoWhite Wheat BurlyWood Tan RosyBrown SandyBrown Goldenrod DarkGoldenrod Peru Chocolate SaddleBrown Sienna Brown Maroon DarkOliveGreen Olive OliveDrab YellowGreen LimeGreen Lime LawnGreen Chartreuse GreenYellow SpringGreen MediumSpringGreen LightGreen PaleGreen DarkSeaGreen MediumSeaGreen SeaGreen ForestGreen Green DarkGreen MediumAquamarine Aqua Cyan LightCyan PaleTurquoise Aquamarine Turquoise MediumTurquoise DarkTurquoise LightSeaGreen CadetBlue DarkCyan Teal LightSteelBlue PowderBlue LightBlue SkyBlue LightSkyBlue DeepSkyBlue DodgerBlue CornflowerBlue SteelBlue RoyalBlue Blue MediumBlue DarkBlue Navy MidnightBlue Lavender Thistle Plum Violet Orchid Fuchsia Magenta MediumOrchid MediumPurple BlueViolet DarkViolet DarkOrchid DarkMagenta Purple Indigo DarkSlateBlue SlateBlue MediumSlateBlue White Snow Honeydew MintCream Azure AliceBlue GhostWhite WhiteSmoke Seashell Beige OldLace FloralWhite Ivory AntiqueWhite Linen LavenderBlush MistyRose Gainsboro LightGray Silver DarkGray Gray DimGray LightSlateGray SlateGray DarkSlateGray Black".split(" ")
                return colors[(~~(colors.length * Math.random()))]
            }
        }

        Button {
            text: "Less."
            onClicked: {
                if (boxes.children.length > 0) {
                    boxes.children[0].destroy()
                }
            }
        }

        Button {
            text: "None."
            onClicked: {
                var kids = boxes.children
                for (var i = 0; i < kids.length; i++) {
                    kids[i].destroy()
                }
            }
        }

        Button {
            text: "Faster!"
            onClicked: boxes.speed = Math.min(boxes.speed + 0.2, 4)
        }

        Button {
            text: "Slower."
            onClicked: boxes.speed = Math.max(boxes.speed - 0.2, 0.2)
        }

        CheckBox {
            id: runCheckbox
            text: "Run"
            checked: true
        }

        CheckBox {
            id: spinCheckbox
            text: "Spin"
        }
    }

    Item {
        id: boxes
        anchors {
            left: parent.left
            right: parent.right
            top: buttons.bottom
            bottom: parent.bottom
            topMargin: 20
        }

        property real speed: 1
    }

    Component {
        id: spinner

        Rectangle {
            id: box
            width: 75
            height: 75
            border {
                width: 2
                color: "black"
            }
            antialiasing: true

            property real targetX
            property real targetY

            RotationAnimation on rotation {
                duration: 1000 / boxes.speed
                from: 0
                to: 360
                loops: Animation.Infinite
                running: spinCheckbox.checked
                alwaysRunToEnd: true
            }

            ParallelAnimation {
                id: move

                SmoothedAnimation {
                    target: box
                    property: "x"
                    to: box.targetX
                    velocity: boxes.width * 0.8 * boxes.speed
                    easing.type: Easing.InOutBack
                }
                SmoothedAnimation {
                    target: box
                    property: "y"
                    to: box.targetY
                    velocity: boxes.height * 0.8 * boxes.speed
                    easing.type: Easing.InOutBack
                }

                onStopped: box.bounce()
            }

            property bool moving: runCheckbox.checked
            onMovingChanged: {
                if (moving) {
                    bounce()
                }
            }

            function bounce() {
                if (moving) {
                    targetX = ~~(boxes.width * Math.random())
                    targetY = ~~(boxes.height * Math.random())
                    move.start()
                }
            }
        }
    }
}

