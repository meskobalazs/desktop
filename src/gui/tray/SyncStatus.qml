import QtQuick 2.15
import QtQuick.Controls 2.15

import com.nextcloud.desktopclient 1.0 as NC

Item {
    property var model: NC.SyncStatusModel {}
    
    ProgressBar {
        // anchors.fill: parent
        value: model.syncProgress
    }
}
