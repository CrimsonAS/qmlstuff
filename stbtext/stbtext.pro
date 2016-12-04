TARGET       = stbtext
TEMPLATE     = lib
TARGETPATH   = com/crimson/stbtext

QT           = core gui qml quick
CONFIG       += plugin

SOURCES      = pluginmain.cpp stbtext.cpp stbfont.cpp
HEADERS      = stbtext.h stbfont.h

load(qml_module)

