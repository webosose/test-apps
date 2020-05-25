import QtQuick 2.4

/*
 * Iamge playback overlay.
 */

Item {
    id: imagePlayback
    opacity: show ? 1.0 : 0.0

    property alias source: imageSurface.source
    property bool show: !!source.toString()

    /* image playback background */
    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
        opacity: 0.5

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
    }

    /* close button */
    Image {
        id: closeButton
        anchors {
            top: parent.top
            right: parent.right
            margins: 0.025 * parent.width
        }
        width: 0.05 * parent.width
        height: width /* square */
        
        source: "icons/close.png"

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
    }

    Image {
        id: imageSurface
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: ""

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
    }
}
