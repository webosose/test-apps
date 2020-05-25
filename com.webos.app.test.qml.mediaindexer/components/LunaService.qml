import QtQuick 2.4
import WebOSServices 1.0
import PmLog 1.0

Service {
    id: luna
    appId: root.appId

    property var logger: null

    signal newPlugin(var plugin)
    signal updatePluginStatus(string uri, bool active)
    signal resetDeviceCount()
    signal updateDevice(string uri, var device)
    signal newItem(var item)
    signal startPlayback(string uri)

    property bool _subscribed: false

    function getPluginList() {
        lunaSend("/getPluginList", '{}');
        if (!_subscribed)
            lunaSend("/getDeviceList", '{ "subscribe": true }');
    }

    function getPlugin(uri) {
        var pl = '{ "uri": "' + uri + '" }';
        lunaSend("/getPlugin", pl);
    }

    function runStopDetect(uri, run) {
        var pl = '{ "uri": "' + uri + '" }';
        lunaSend(run ? "/runDetect" : "/stopDetect", pl);
    }

    function lunaSend(method, payload) {
        call("luna://com.webos.service.mediaindexer", method, payload);
    }

    function getPlaybackUri(uri) {
        logger.info("LUNA", { "Get playback uri for": uri });
        var pl = '{ "uri": "' + uri + '" }';
        lunaSend("/getPlaybackUri", pl);
    }

    function searchMedia(payload) {
        logger.info("LUNA", { "Searching media database for": payload });
        call("luna://com.webos.service.db", "/search", payload);
    }

    function playVideo(uri) {
        logger.info("LUNA", { "Play video": uri });
        var payload = '{ "uri": "' + uri + '", "type": "media" }';
        call("luna://com.webos.media", "/load", payload);
    }

    onResponse: {
        if (logger)
            logger.info("LUNA", { "Received method": method });

        switch (method) {
        case "/runDetect":
        case "/stopDetect":
        case "/getPlugin":
        case "/putPlugin":
            break;
        case "/getPluginList":
            var pl = JSON.parse(payload);
            var plugins = pl.pluginList;
            for (var plg in plugins) {
                /* fill the plugin model */
                luna.newPlugin({ uri: plugins[plg].uri, running: false,
                            deviceCount: 0 });
                /* make the plugin available */
                getPlugin(plugins[plg].uri);
            }
            break;
        case "/getDeviceList":
            _subscribed = true;
            var pl = JSON.parse(payload);
            var plugins = pl.pluginList;
            luna.resetDeviceCount();
            for (var plg in plugins) {
                /* update state of plugin */
                luna.updatePluginStatus(plugins[plg].uri, plugins[plg].active);
                var devices = plugins[plg].deviceList;
                for (var dev in devices)
                    luna.updateDevice(plugins[plg].uri, devices[dev]);
            }
            break;
        case "/search":
            var pl = JSON.parse(payload);
            var count = pl.count;
            logger.info("LUNA", { "Received number of items": count });
            var items = pl.results;
            for (var item in items) {
                logger.info("LUNA", { "Received media item": items[item].title });
                luna.newItem(items[item]);
            }
            break;
        case "/getPlaybackUri":
            var pl = JSON.parse(payload);
            var uri = pl.playbackUri;
            logger.info("LUNA", { "Start playback on": uri });
            luna.startPlayback(uri.toString());
            break;
        case "/load":
            var pl = JSON.parse(payload);
            var mediaId = pl.mediaId;
            var payload = '{ "mediaId": "' + mediaId + '" }';
            call("luna://com.webos.media", "/play", payload);
            break;
        default:
            /* nothing to be done */
            break;
        }
    }

    onError: {
        if (logger)
            logger.error("LUNA", {"error": "some error"});
    }
}
