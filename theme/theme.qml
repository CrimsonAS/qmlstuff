import QtQuick 2.6

Rectangle {
    width: 500
    height: 500
    color: theme.backgroundColor

    QtObject {
        id: theme
        property string backgroundColor: "#e7eacc"
        property var contrastColors: [
            "#ed1d45", // red
            "#ed2b27", // redder
            "#f9840a", // orange
            "#fec609", // yellow
            "#7e7f85", // grey
            "#57b94e", // green
            "#53bbf3", // blue
            "#474d93", // blue2
            "#d098a3", // pink?
            "#bfbfbf", // grey2
            "#82603e", // brown
            "#5c5c62", // grey3
            "#f9840a", // orange2
        ]
        property string textColorPrimary: contrastColors[11]
        property string textColorSecondary: contrastColors[4]
        property string textColorTertiary: contrastColors[9]

        property string emphasisColorPrimary: contrastColors[2]
        property string emphasisColorSecondary: contrastColors[6]
        property string emphasisColorTertiary: contrastColors[10]
    }

    Column {
        x: 50
        y: 50
        Row {
            spacing: 5
            Repeater {
                model: theme.contrastColors

                Rectangle {
                    color: modelData
                    width: 30
                    height: 30
                }
            }
        }

        Repeater {
            model: [
                theme.textColorPrimary,
                theme.textColorSecondary,
                theme.textColorTertiary
            ]
            Text {
                font.pixelSize: 50
                text: "I'm regular old text!"
                color: modelData
            }
        }
        Repeater {
            model: [
                theme.emphasisColorPrimary,
                theme.emphasisColorSecondary,
                theme.emphasisColorTertiary
            ]
            Text {
                font.pixelSize: 50
                text: "I'm emphasized!"
                color: modelData
            }
        }
    }
}
