import QtQuick 2.4

ListModel {
    id: mediaItemModel

    ListElement {
        uri: "/audio"
        title: "Audio"
        info: "All Audio"
    }

    ListElement {
        uri: "/artists"
        title: "Audio Artists"
        info: "All Artists"
    }

    ListElement {
        uri: "/albums"
        title: "Audio Albums"
        info: "All Albums"
    }

    ListElement {
        uri: "/video"
        title: "Video"
        info: "All Videos"
    }

    ListElement {
        uri: "/images"
        title: "Images"
        info: "All Images"
    }
}
