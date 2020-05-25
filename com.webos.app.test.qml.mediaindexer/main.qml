import QtQuick 2.4
import QtQuick.Window 2.4
import WebOSServices 1.0
import Eos.Window 0.1
import PmLog 1.0

/* Test application for mediaindexer service
 *
 * Initial view is a list of plugins available in the top row, you can
 * click the icons to enable/disable the detection state, the
 * operation on click is indicated with the play/stop symbol below the
 * icon. At the top/right corner of the plugin icons is an indication
 * of the number of detected devices for that plugin, the color
 * indicates whether device detection is currently active or not.
 *
 * If a device has been detected or devices are already known from the
 * device database you can see them on the bottom part of the
 * screen. The devices are greyed out if not available, for the UPNP
 * servers the server icon is shown if available. Otherwise and for
 * all other devices a placeholder icon is used which is the icon from
 * the plugin bar.
 *
 * There is an entry 'All Devices' which allows browsing over device
 * boundaries.
 *
 * Clicking an available device shows the browsing view where you can
 * select different file types and get the list of all files that
 * belong to that type.
 *
 * Clicking an item from the browse page should start the playback of
 * that item, currently only images are supported.
 *
 * The code is splitted into the main QML file which is this one and
 * several component files in the ./components subdirectory.
 *
 * Within the components there are delegate and model definitions for
 * the plugin, the device and the browse view. Then there are some
 * special modules, one that contains all LUNA API usage and helper
 * functions and the playback modules for audio, video and images.
 */

WebOSWindow {
    id: root
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    appId: "com.webos.mediaindexer.app.qml"
    title: "Media indexer test app"
    color: "black"

    property var launchParams: params
    onLaunchParamsChanged: {
        pmLog.info("LAUNCH_PARAMS", {"params": launchParams})
    }

    onWindowStateChanged: {
        pmLog.info("WINDOW_CHANGED", {"status": windowState})
        if (windowState == 4)
            lunaService.getPluginList();
    }

    /* list of available plugins and their state as well as number of
     * detected devices */
    PluginModel {
        id: pluginModel
    }

    ListView {
        id: pluginView
        visible: !!pluginModel.count

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 0.2 * iconSize
        }
        width: iconSize * (2 * model.count - 1)
        height: iconSize + 2 * textSize
        orientation: ListView.Horizontal
        spacing: iconSize

        /* animations */
        add: Transition {
            NumberAnimation {
                properties: "x"
                from: root.width / 2
                duration: 1000
            }
        }
        addDisplaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 1000
            }
        }

        model: pluginModel

        property real iconSize: root.width / (2 * model.count + 1)
        property real textSize: 0.1 * iconSize

        delegate: PluginDelegate {
            width: pluginView.iconSize
            height: width /* square */
            luna: lunaService
        }
    }

    Rectangle {
        id: separator
        width: root.width
        height: 2
        anchors {
            horizontalCenter: root.horizontalCenter
            top: pluginView.bottom
            topMargin: pluginView.textSize
        }
    }

    DeviceModel {
        id: deviceModel
        logger: pmLog
    }

    ListView {
        id: deviceView
        visible: !!deviceModel.count

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: separator.bottom
            topMargin: pluginView.textSize
        }
        width: root.width
        height: root.height - y
        orientation: ListView.Vertical

        /* animations */
        add: Transition {
            NumberAnimation {
                properties: "x"
                from: root.width
                duration: 1000
            }
        }
        addDisplaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 1000
            }
        }

        model: deviceModel

        property real rowHeight: 0.1 * root.height

        delegate: DeviceDelegate {
            width: deviceView.width
            height: deviceView.rowHeight

            textColor: mediaItemView.uri === uri ? "yellow" : "white"

            onClicked: {
                if (mediaItemView.uri === uri)
                    mediaItemView.uri = "";
                else
                    mediaItemView.uri = uri;
            }
        }
    }

    MediaItemModel {
        id: mediaItemModel
        logger: pmLog
    }

    MediaItemDefaultModel {
        id: mediaItemDefaultModel
    }

    /* background for media item view */
    Rectangle {
        anchors.fill: mediaItemView
        color: "black"

        Rectangle {
            width: 5
            height: parent.height
            anchors {
                right: parent.left
                top: parent.top
            }

            color: "yellow"
        }
    }

    ListView {
        id: mediaItemView
        clip: true

        property string query: "/"
        property string uri: ""
        onUriChanged: query = "/" /* reset to default model on new
                                   * device */

        anchors {
            left: parent.right
            top: deviceView.top
        }
        width: root.width / 2
        height: root.height - y
        orientation: ListView.Vertical

        state: !!uri ? "show" : "hide"
        states: [
            State {
                name: "hide"
                AnchorChanges { target: mediaItemView
                                anchors.left: parent.right }
            },
            State {
                name: "show"
                AnchorChanges { target: mediaItemView
                                anchors.left: parent.horizontalCenter }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 1000 }
        }

        model: query === "/" ? mediaItemDefaultModel : mediaItemModel
        onModelChanged: if (model === mediaItemModel) mediaItemModel.reset()

        function itemClicked(newUri) {
            var typeFilter = '{ "prop": "dirty", "op": "=", "val": false }';
            var selected = "";
            var distinct = "";

            switch (newUri) {
            case "/audio":
                mediaItemView.query = newUri;
                selected = '["uri", "title", "artist", "album"]';
                typeFilter += ', { "prop": "type", "op": "=", "val": "audio"}';
                break;
            case "/artists":
                mediaItemView.query = newUri;
                distinct = '"distinct": "album_artist"';
                selected = '["album_artist"]';
                typeFilter += ', { "prop": "type", "op": "=", "val": "audio"}';
                break;
            case "/albums":
                mediaItemView.query = newUri;
                distinct = '"distinct": "album"';
                selected = '["album"]';
                typeFilter += ', { "prop": "type", "op": "=", "val": "audio"}';
                break;
            case "/video":
                mediaItemView.query = newUri;
                selected = '["uri", "title", "duration"]';
                typeFilter += ', { "prop": "type", "op": "=", "val": "video"}';
                break;
            case "/images":
                mediaItemView.query = newUri;
                selected = '["uri", "title"]';
                typeFilter += ', { "prop": "type", "op": "=", "val": "image"}';
                break;
            case "/":
                mediaItemView.query = newUri;
                break;
            default:
                lunaService.getPlaybackUri(newUri);
                break;
            }

            if (!selected) return;

            var select = '"select": ' + selected;
            var from = '"from": "com.webos.service.mediaindexer.media:1"';
            var uriWhere = '{ "prop": "uri", "op": "%", "val": "' + mediaItemView.uri + '"}';
            var where = '"where": [ ' + uriWhere + ' ]';
            var filter = '"filter": [ ' + typeFilter + ' ]';
            var query = '"query": { ' + select + ', ' + from + ', ' + filter;
            if (distinct)
                query = '"query": { ' + distinct + ', ' + select + ', ' + from + ', ' + filter;
            /* for this special device uri the search will be
             * performed throughout all devices */
            if (mediaItemView.uri !== "__ALL__")
                query += ', ' + where + ' }';
            else
                query += ' }';

            var search = '{ ' + query + ' }'

            lunaService.searchMedia(search);
        }

        delegate: MediaItemDelegate {
            width: mediaItemView.width
            height: 0.1 * 0.7 * root.height

            onClicked: ListView.view.itemClicked(uri)
        }
    }

    AudioPlayback {
        id: audioPlayback
        anchors.fill: parent
    }

    VideoPlayback {
        id: videoPlayback
        anchors.fill: parent
        onStatusChanged: pmLog.info("VIDEO", {"status": status})
        onSourceChanged: pmLog.info("VIDEO", {"source": source.toString()})
        onAvailChanged: pmLog.info("VIDEO", {"avail": avail.toString()})
    }

    ImagePlayback {
        id: imagePlayback
        anchors.fill: parent
    }

    LunaService {
        id: lunaService
        logger: pmLog

        onNewPlugin: pluginModel.append(plugin)
        onUpdatePluginStatus: pluginModel.setRunning(uri, active)
        onResetDeviceCount: pluginModel.resetDeviceCount()
        onUpdateDevice: {
            /* if the device which is currently browsed becomes
             * unavailable we need to close the browse view */
            if (mediaItemView.uri.startsWith(uri) && !device.available)
                mediaItemView.uri = "";
            deviceModel.update(uri, device);
        }
        onNewItem: mediaItemModel.appendItem(item, mediaItemView.query)
        onStartPlayback: {
            switch (mediaItemView.query) {
            case "/audio":
                audioPlayback.source = uri;
                break;
            case "/video":
                videoPlayback.source = uri;
                /* lunaService.playVideo(uri); */
                break;
            case "/images":
                imagePlayback.source = uri;
                break;
            }
        }
    }

    PmLog {
        id: pmLog
        context: "MediaIndexerApp"
    }

    MouseArea {
        anchors.fill: parent
        enabled: audioPlayback.show || videoPlayback.show ||
            imagePlayback.show
        onClicked: {
            audioPlayback.source = "";
            videoPlayback.source = "";
            imagePlayback.source = "";
        }
    }
}
