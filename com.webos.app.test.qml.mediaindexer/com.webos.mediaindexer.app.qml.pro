TEMPLATE = aux
!load(webos-variables):error("Cannot load webos-variables.prf")

# install
defined(WEBOS_INSTALL_WEBOS_APPLICATIONSDIR, var) {
    INSTALL_APPDIR = $$WEBOS_INSTALL_WEBOS_APPLICATIONSDIR/com.webos.mediaindexer.app.qml
    target.path = $$INSTALL_APPDIR

    appinfo.path = $$INSTALL_APPDIR
    appinfo.files = appinfo.json

    base.path = $$INSTALL_APPDIR
    base.files = main.qml \
                 components/PluginDelegate.qml \
                 components/DeviceDelegate.qml \
                 components/MediaItemDelegate.qml \
                 components/LunaService.qml \
                 components/DeviceModel.qml \
                 components/PluginModel.qml \
                 components/MediaItemModel.qml \
                 components/MediaItemDefaultModel.qml \
                 components/AudioPlayback.qml \
                 components/VideoPlayback.qml \
                 components/ImagePlayback.qml

    # icons
    icon.path = $$INSTALL_APPDIR
    icon.files = icon.png
    icons.path = $$INSTALL_APPDIR/icons

    # control
    icons.files += icons/play.png \
                   icons/stop.png \
                   icons/close.png

    # remote device types
    icons.files += icons/camera.png \
                   icons/server.png \
                   icons/usb.png \
                   icons/mobile.png \
                   icons/storage.png

    # media types
    icons.files += icons/film.png \
                   icons/music.png \
                   icons/images.png

    INSTALLS += target appinfo base icon icons
}
