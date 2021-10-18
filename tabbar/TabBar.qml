import QtQuick 2.6

Rectangle {
    width: 500
    height: 500
    color: "black"

    Shortcut {
        sequence: "Ctrl+T"
        onActivated: {
            internalTabModel.append({ title: "Dynamic tab " + internalTabModel.count })
        }
    }
    Shortcut {
        sequence: "Ctrl+W"
        onActivated: {
            internalTabModel.remove(internalTabModel.count -1)
        }
    }

    Column {
        width: parent.width
        Rectangle {
            id: tabBar
            color: "black"
            width: parent.width
            height: tabHeight
            visible: height > 0
            property int internalAnimationDuration: 100
            property int selectedIndex
            property int tabHeight: model.count > 1 ? 25 : 0
            Behavior on tabHeight {
                NumberAnimation {
                    duration: tabBar.internalAnimationDuration
                }
            }
            property int maxTabWidth: 200
            property int internalMaxVisibleTabs: 8
            property real minTabWidth: (width / internalMaxVisibleTabs)// - internalShowMoreIndicatorWidth
            property int internalShowMoreIndicatorWidth: 20
            property alias model: internalTabModel
            property real internalCurrentTabWidth: Math.max(tabBar.minTabWidth, Math.min(tabBar.maxTabWidth, tabBar.width / tabBar.model.count))
            Behavior on internalCurrentTabWidth {
                NumberAnimation {
                    duration: tabBar.internalAnimationDuration
                }
            }

            ListView {
                orientation: Qt.Horizontal
                interactive: false
                anchors.fill: parent
                model: ListModel {
                    id: internalTabModel
                    ListElement {
                        title: "tab 1"
                    }
                    ListElement {
                        title: "tab 2"
                    }
                    ListElement {
                        title: "tab 3"
                    }
                    ListElement {
                        title: "a tab with some very very very long text indeed"
                    }
                }
                delegate: Rectangle {
                    id: delegateItem
                    ListView.onAdd: SequentialAnimation {
                        PropertyAction {
                            target: delegateItem
                            property: "width"
                            value: 0
                        }
                        NumberAnimation {
                            target: delegateItem
                            property: "width"
                            to: tabBar.internalCurrentTabWidth
                            duration: tabBar.internalAnimationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                    ListView.onRemove: SequentialAnimation {
                        PropertyAction {
                            target: delegateItem;
                            property: "ListView.delayRemove";
                            value: true
                        }
                        NumberAnimation {
                            target: delegateItem
                            property: "width"
                            to: 0
                            duration: tabBar.internalAnimationDuration
                            easing.type: Easing.InOutQuad
                        }
                        PropertyAction {
                            target: delegateItem;
                            property: "ListView.delayRemove";
                            value: false
                        }
                    }

                    width: tabBar.internalCurrentTabWidth
                    height: tabBar.tabHeight

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            tabBar.selectedIndex = index
                            console.log("Selected " + index)
                        }
                    }

                    MouseArea {
                        id: closeIcon
                        height: parent.height
                        width: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        onClicked: internalTabModel.remove(index)

                        Text {
                            text: "x"
                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        id: tabTitle
                        text: model.title
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: closeIcon.right
                        anchors.right: parent.right
                        anchors.margins: 10
                        elide: Text.ElideRight
                    }

                    Rectangle {
                        anchors.right: parent.right
                        width: 1
                        height: parent.height
                        color: "black"
                    }
                }
            }
            Rectangle {
                x: parent.width - width
                height: parent.height
                width: tabBar.internalShowMoreIndicatorWidth
                color: "red"
                visible: tabBar.model.count > tabBar.internalMaxVisibleTabs

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        for (var j = tabBar.internalMaxVisibleTabs; j < tabBar.model.count; ++j) {
                            console.log(j + " " + JSON.stringify(tabBar.model.get(j)))
                        }
                    }
                }
            }
        }

        Text {
            color: "white"
            text: "Selected index is " + tabBar.selectedIndex
        }
    }
}
