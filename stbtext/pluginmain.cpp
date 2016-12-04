#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/qqml.h>

#include "stbtext.h"

class PluginMain : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri)
    {
        qmlRegisterType<StbText>(uri, 1, 0, "StbText");
        qmlRegisterType<StbFont>(uri, 1, 0, "StbFont");
    }
};

#include "pluginmain.moc"

