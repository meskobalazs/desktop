import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import com.nextcloud.desktopclient 1.0 as NC

Item {
    id: item

    property var model: NC.SyncStatusModel {}

    implicitHeight: layout.height

    RowLayout {
        id: layout

        width: item.width

        Image {
            Layout.margins: 8
            sourceSize.width: 32
            sourceSize.height: 32
            source: model.syncIcon
        }

        ColumnLayout {

            Text {}
            
            ProgressBar {
                Layout.margins: 8
                Layout.fillWidth: true

                value: model.syncProgress
                visible: model.syncing
            }

        }

    }
}
