import QtQuick 2.4

Rectangle {
    id: deviceDelegate
    opacity: available ? 1.0 : 0.5

    color: index % 2 ? "darkgrey" : "black"

    property alias textColor: nameField.color

    signal clicked(string uri)

    Image {
        id: icon
        anchors {
            left: parent.left
            leftMargin: parent.height / 2
            verticalCenter: parent.verticalCenter
        }
        width: 0.8 * parent.height
        height: width /* square */
        fillMode: Image.PreserveAspectFit
        source: {
            /* check if the device comes with its own icon */
            if (iconUrl) return iconUrl;

            /* select default icon for device class */
            switch (uri) {
            case String(uri.match(/^mtp.*/)): return "icons/mobile.png";
            case String(uri.match(/^msc.*/)): return "icons/usb.png";
            case String(uri.match(/^upnp.*/)): return "icons/server.png";
            case String(uri.match(/^storage.*/)): return "icons/storage.png";
            }

            return "";
        }
    }

    Text {
        id: nameField
        anchors {
            left: icon.right
            leftMargin: parent.height / 2
            top: icon.top
        }
        font {
            pixelSize: 0.4 * parent.height
            bold: true
        }
        color: "white"
        text: name
    }

    Text {
        id: descriptionField
        anchors {
            left: icon.right
            leftMargin: parent.height / 2
            bottom: icon.bottom
        }
        font {
            pixelSize: 0.2 * parent.height
        }
        color: nameField.color
        text: description
    }

    Column {
        id: mediaItemCountView
        spacing: 10
        anchors {
            right: parent.right
            rightMargin: parent.height / 2
            verticalCenter: parent.verticalCenter
        }

        Repeater {
            model: 3

            delegate: Rectangle {
                radius: height / 2
                width: 6 * height
                height: 0.25 * deviceDelegate.height
                color: switch (index) {
                    case 0: return "lightskyblue";
                    case 1: return "lightsalmon";
                    case 2: return "lightgreen";
                }

                Image {
                    width: height /* square */
                    height: 0.8 * parent.height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                    source: switch (index) {
                        case 0: return "icons/music.png";
                        case 1: return "icons/film.png";
                        case 2: return "icons/images.png";
                    }
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 10
                    }
                    font.pixelSize: 0.8 * parent.height
                    color: "black"
                    text: switch (index) {
                        case 0: return audioCount;
                        case 1: return videoCount;
                        case 2: return imageCount;
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: available
        onClicked: deviceDelegate.clicked(uri)
    }
}
