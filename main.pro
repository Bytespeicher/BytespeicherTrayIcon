TEMPLATE = app
CONFIG += debug_and_release ordered
TARGET = byteicon
QT += network core gui widgets
SOURCES = main.cpp
HEADERS += main.h
RESOURCES = resources.qrc

QMAKE_CXXFLAGS += -std=c++11

unix {
  PKG = $$system(pkg-config --libs QtDBus)
  contains(PKG, -lQtDBus) {
    message( \
      "QtDBus found, configuring with NetworkManager and Notification support")
    QT += dbus
    DEFINES += HAVE_DBUS
    SOURCES += freedesktop-notification.cpp
    HEADERS += freedesktop-notification.h
  }
  !contains(PKG, -lQtDBus) {
    message( \
      "Configuring without D-Bus. No Notification and NetworkManager support.")
  }
}

CONFIG(release, debug|release) {
    #This is a release build
    DEFINES += QT_NO_DEBUG_OUTPUT
}

win32 {
  RC_FILE = res/resources.rc
}

macx {
  ICON = res/s0trayicon.icns
}
macx:universal {
  CONFIG += x86 ppc
}
macx:noicon {
  QMAKE_INFO_PLIST = res/Info-noicon.plist
}
macx:!noicon {
  QMAKE_INFO_PLIST = res/Info-icon.plist
}

TRANSLATIONS += lang/main_ca-ES.ts \
                lang/main_cs-CZ.ts \
                lang/main_de-DE.ts \
                lang/main_el-GR.ts \
                lang/main_es-ES.ts \
                lang/main_fr-FR.ts \
                lang/main_hi-IN.ts \
                lang/main_it-IT.ts \
                lang/main_ka-GE.ts \
                lang/main_pt-BR.ts \
                lang/main_ro-RO.ts \
                lang/main_ru.ts \
                lang/main_pt-BR.ts \
                lang/main_zh-CN.ts
                
TRANSLATIONS_FILES =

qtPrepareTool(LRELEASE, lrelease)
for(tsfile, TRANSLATIONS) {
  qmfile = $$shadowed($$tsfile)
  qmfile ~= s,.ts$,.qm,
  qmdir = $$dirname(qmfile)
  !exists($$qmdir) {
    mkpath($$qmdir) | error("Aborting.")
  }
  command = $$LRELEASE -removeidentical $$tsfile -qm $$qmfile
  system($$command)|error("Failed to run: $$command")
  TRANSLATIONS_FILES += $$qmfile
}
