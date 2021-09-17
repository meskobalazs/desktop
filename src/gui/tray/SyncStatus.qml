import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Style 1.0

import com.nextcloud.desktopclient 1.0 as NC

Item {
    id: item

    property var model: NC.SyncStatusModel {}

    implicitHeight: layout.height

    RowLayout {
        id: layout

        Layout.alignment: Qt.AlignLeft

        width: item.width

        Image {
            Layout.alignment: Qt.AlignLeft
            Layout.margins: 8
            sourceSize.width: 32
            sourceSize.height: 32
            source: model.syncIcon
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft

            Text {
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 8
                Layout.fillWidth: true

                text: model.syncStatusString
                font.pixelSize: Style.topLinePixelSize
            }

            ProgressBar {
                Layout.alignment: Qt.AlignLeft
                Layout.rightMargin: 8
                Layout.fillWidth: true

                value: model.syncProgress
                visible: model.syncing
            }

            Text {
                Layout.alignment: Qt.AlignLeft
                Layout.bottomMargin: 8
                Layout.fillWidth: true

                text: model.syncString
                visible: model.syncing
                font.pixelSize: Style.subLinePixelSize
            }

        }

    }
}
