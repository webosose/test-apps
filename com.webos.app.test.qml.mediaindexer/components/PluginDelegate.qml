import QtQuick 2.4

Item {
    id: del

    property var luna: null

    Image {
        id: icon
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: {
            switch (uri) {
            case "mtp": return "icons/mobile.png";
            case "msc": return "icons/usb.png";
            case "upnp": return "icons/server.png";
            case "storage": return "icons/storage.png";
            }
        }
    }

    Rectangle {
        anchors {
            left: parent.right
            leftMargin: 0.2 * width
            top: parent.top
        }
        width: 0.2 * parent.height
        height: width /* square */
        radius: width / 2 /* circle */
        color: running ? "yellow" : "red"

        Text {
            anchors.centerIn: parent
            color: running ? "black" : "white"
            font {
                pixelSize: 0.9 * parent.height
                bold: true
            }
            text: deviceCount.toString()
        }
    }

    Row {
        id: controls
        anchors.top: icon.bottom
        anchors.topMargin: spacing
        anchors.horizontalCenter: icon.horizontalCenter
        spacing: 0.5 * pluginView.textSize

        Image {
            width: pluginView.textSize
            height: width /* square */
            fillMode: Image.PreserveAspectFit
            source: running ? "icons/stop.png" : "icons/play.png"
        }

        Text {
            color: "white"
            font {
                pixelSize: pluginView.textSize
                bold: true
            }
            text: uri.toUpperCase()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: if (luna) luna.runStopDetect(uri, !running)
    }
}
