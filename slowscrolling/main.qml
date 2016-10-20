import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Window {
    visible: true;
    width: 1280;
    height: 720;

    property string fontFamily: dummyLabel.font.family;
    Label {
        id: dummyLabel;
        Component.onCompleted: {
            console.log( "PhxTheme: Using system font \"" + font.family + "\"" );
        }
    }

    ScrollView {
        anchors.fill: parent;
        GridView {
            id: gridView;
            anchors.fill: parent;
            model: 100000;
            //cacheBuffer: 10000000;
            delegate:
            /*Loader {

                asynchronous: true;
                sourceComponent: */Rectangle {
                    width: gridView.cellWidth;
                    height: gridView.cellHeight;
                    color: Qt.rgba( Math.random(), Math.random(), Math.random(), 0.75 );
                    ColumnLayout {
                        anchors.fill: parent;
                        anchors.margins: 8;
                        Image {
                            Layout.fillHeight: true;
                            asynchronous: true;
                            anchors { left: parent.left; right: parent.right; }
                            source: "noartwork.png";
                            sourceSize { height: 200; width: 200; }
                            verticalAlignment: Image.AlignBottom;
                            fillMode: Image.PreserveAspectFit;
                        }

                        MarqueeText {
                            width: parent.width
                            height: 12
                        }
                    }
                }

            //}
        }
    }

}
