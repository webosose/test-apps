import QtQuick 2.4
import QtMultimedia 5.11

/*
 * Video playback overlay.
 */

Item {
    id: videoPlayback
    opacity: show ? 1.0 : 0.0

    property alias source: videoPlayer.source
    property alias status: videoPlayer.status
    property alias avail: videoPlayer.availability

    property bool show: !!source.toString()
    onShowChanged: {
        if (show) {
            pmLog.info("VIDEO", {"player": "start"})
            videoPlayer.play();
        } else {
            pmLog.info("VIDEO", {"player": "stop"})
            videoPlayer.stop();
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 1000 }
    }

    /* image playback background */
    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
        opacity: 0.5
    }

    /* title text */
    Text {
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 0.1 * parent.height
        }
        font {
            pixelSize: 0.1 * parent.height
            bold: true
        }
        text: "FIXME: -" //videoPlayer.metaData.title
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
    }

    /* playback position */
    Rectangle {
        width: 0.8 * parent.width
        height: 10
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 0.1 * parent.height
        }
        color: "grey"

        Rectangle {
            width: videoPlayer.position / videoPlayer.duration *
                parent.width
            height: parent.height
            anchors {
                left: parent.left
                top: parent.top
            }
            color: "white"
        }
    }

    Video {
        id: videoPlayer
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent
        source: ""
    }
}
