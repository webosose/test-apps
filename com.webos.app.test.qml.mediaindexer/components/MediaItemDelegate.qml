import QtQuick 2.4

Rectangle {
    id: mediaItemDelegate

    color: index % 2 ? "darkgrey" : "black"

    signal clicked(string uri)

    Image {
        id: album_art
        anchors {
            left: parent.left
	    leftMargin: parent.height / 2
            top: parent.top
        }
        width: type == "audio" ? parent.height : 0;
        height: parent.height;
        source: thumbnail
    }

    Text {
        id: titleField
        anchors {
            left: album_art.right//parent.left
            leftMargin: parent.height / 4
            top: parent.top
        }
        font {
            pixelSize: 0.4 * parent.height
            bold: true
        }
        color: "white"
        text: title
    }

    Text {
        id: infoField
        anchors {
            left: album_art.right//parent.left
            leftMargin: parent.height / 4
            bottom: parent.bottom
        }
        font {
            pixelSize: 0.4 * parent.height
        }
        color: "lightgrey"
        text: info
    }

    MouseArea {
        anchors.fill: parent
        onClicked: mediaItemDelegate.clicked(uri)
    }
}
