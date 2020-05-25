import QtQuick 2.4

ListModel {
    id: deviceModel

    property var logger: null

    ListElement {
        uri: "__ALL__"
        audioCount: 0
        videoCount: 0
        imageCount: 0
        available: false
        name: "All Devices"
        description: "--"
        iconUrl: ""
    }

    function update(uri, device) {
        if (logger)
            logger.info("LUNA", { "Update device model for": device.name });

        pluginModel.incDeviceCount(uri);

        for (var i = 0; i < count; i++) {
            if (get(i).uri == device.uri) {
                /* check for changes */
                if (get(i).name != device.name)
                    setProperty(i, "name", device.name);
                if (get(i).description != device.description)
                    setProperty(i, "description", device.description);
                if (get(i).icon != device.icon)
                    setProperty(i, "iconUrl", device.icon);
                if (get(i).audioCount != device.audioCount) {
                    setProperty(i, "audioCount", device.audioCount);
                    updateHeader();
                }
                if (get(i).videoCount != device.videoCount) {
                    setProperty(i, "videoCount", device.videoCount);
                    updateHeader();
                }
                if (get(i).imageCount != device.imageCount) {
                    setProperty(i, "imageCount", device.imageCount);
                    updateHeader();
                }
                if (get(i).available != device.available) {
                    setProperty(i, "available", device.available);
                    if (device.available)
                        deviceModel.move(i, 1, 1);
                    else
                        deviceModel.move(i, deviceModel.count - 1, 1);
                    updateHeader();
                }
                return; /* device already found - leave */
            }
        }

        var iconUrl = device.icon ? device.icon : "";
        if (device.available)
            deviceModel.insert(1, { uri: device.uri,
                                    audioCount: device.audioCount,
                                    videoCount: device.videoCount,
                                    imageCount: device.imageCount,
                                    available: device.available,
                                    name: device.name,
                                    description: device.description,
                                    iconUrl: iconUrl });
        else
            deviceModel.append({ uri: device.uri,
                                 audioCount: device.audioCount,
                                 videoCount: device.videoCount,
                                 imageCount: device.imageCount,
                                 available: device.available,
                                 name: device.name,
                                 description: device.description,
                                 iconUrl: iconUrl });
        updateHeader();
    }

    function updateHeader() {
        var ac = 0, vc = 0, ic = 0;
        var avail = false;
        for (var i = 1; i < deviceModel.count; ++i) {
            /* update available state for header item */
            if (get(i).available) avail = true;

            /* udpate the media item counts */
            ac += get(i).audioCount;
            vc += get(i).videoCount;
            ic += get(i).imageCount;
        }

        setProperty(0, "available", avail);

        setProperty(0, "audioCount", ac);
        setProperty(0, "videoCount", vc);
        setProperty(0, "imageCount", ic);
    }
}
