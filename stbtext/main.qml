import QtQuick 2.4
import com.crimson.stbtext 1.0

Rectangle
{
    width: 320
    height: 480

    gradient: Gradient {
        GradientStop { position: 0; color: "white" }
        GradientStop { position: 1; color: "steelblue" }
    }

    StbFont {
        id: openSansFont
        font: "OpenSans-Regular.ttf"
        size: 30
    }

    Rectangle {
        color: "white"
        height: 1
        y: 100
        width: parent.width
    }

    Rectangle {
        color: "white"
        x: 100
        height: parent.height
        width: 1
    }

    StbText {
        x: 100
        y: 100
        text: "Hello World! \u03A6"
        font: openSansFont
    }

}