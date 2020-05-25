import QtQuick 2.4

ListModel {
    id: pluginModel

    function setRunning(uri, flag) {
        for (var i = 0; i < count; i++) {
            if (get(i).uri != uri) continue;
            setProperty(i, "running", flag);
            break;
        }
    }

    function resetDeviceCount() {
        for (var i = 0; i < count; i++)
            setProperty(i, "deviceCount", 0);
    }

    function incDeviceCount(uri) {
        for (var i = 0; i < count; i++) {
            if (get(i).uri != uri) continue;
            var c = get(i).deviceCount;
            setProperty(i, "deviceCount", ++c);
            break;
        }
    }
}
