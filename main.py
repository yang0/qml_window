# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import (QDateTime, QDir, QFileInfo, QLibraryInfo, QMetaObject,
                            QSysInfo, QTextStream, QTimer, QUrl, Qt, Slot,Signal, qVersion)


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    url = QUrl("main.qml")
    engine.load(url)
#    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
