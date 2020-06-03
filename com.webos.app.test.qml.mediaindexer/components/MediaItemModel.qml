import QtQuick 2.4

ListModel {
    id: mediaItemModel

    property var logger: null

    function reset() {
        mediaItemModel.clear();
        mediaItemModel.insert(0, { uri: "/",
                                   title: "Back",
                                   info: "Back to Root Menu" });
    }

    function appendItem(item, query) {
        var _info = "--";
        var _title = "--";

        switch (query) {
        case "/audio":
            _title = item.title;
            _info = item.artist + " - " + item.album;
            break;
        case "/artists":
            _title = item.album_artist;
            break;
        case "/albums":
            _title = item.album;
            break;
        case "/video":
            _title = item.title;
            _info = item.duration.toString();
            break;
        case "/images":
            _title = item.title;
            break;
        case "/":
            break;
        default:
            break;
        }

        mediaItemModel.append({ uri: item.uri,
                                title: _title,
                                info: _info });
    }
}
