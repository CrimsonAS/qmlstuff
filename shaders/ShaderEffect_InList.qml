import QtQuick 2.0

Rectangle {
    id: root
    width: 320
    height: 480

    gradient: Gradient {
        GradientStop { position: 0; color: "palegreen" }
        GradientStop { position: 1; color: "black" }
    }

    property var theItem;

    Rectangle {
        radius: 20
        width: root.width / 2
        height: 30

        border.width: 2
        border.color: "steelblue"
        color: "lightsteelblue"

        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Text {
            anchors.centerIn: parent
            text: "Create"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (theItem)
                    return;
                print("creating");
                theItem = Qt.createQmlObject("
                    import QtQuick 2.0;
                    ShaderEffect {
                        width: 100;
                        height: 100;
                        anchors.centerIn: parent;
//                        property Item source: Image { source: 'icons/icon0.png' }
                    }", root, "shaderthingy.qml");
            }
        }
    }

    Rectangle {
        radius: 20
        width: root.width / 2
        height: 30

        border.width: 2
        border.color: "steelblue"
        color: "lightsteelblue"

        anchors.bottom: parent.bottom
        anchors.right: parent.right

        Text {
            anchors.centerIn: parent
            text: "Destroy"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (theItem) {
                    print("destroy...");
                    theItem.destroy();
                    theItem = undefined;
                }
            }
        }
    }

}
