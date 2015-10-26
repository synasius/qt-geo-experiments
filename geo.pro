TEMPLATE = app

QT += qml quick location positioning

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

ios {
    QMAKE_INFO_PLIST = Info.plist
}
