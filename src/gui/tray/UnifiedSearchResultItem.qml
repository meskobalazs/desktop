import QtQml 2.12
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import Style 1.0
import com.nextcloud.desktopclient 1.0
import QtGraphicalEffects 1.0

MouseArea {
    id: unifiedSearchResultMouseArea

    property int defaultHeight: 0

    readonly property int contentLeftMargin: 8
    readonly property int contentRightMargin: contentLeftMargin

    readonly property int typeCategorySeparator: 1
    readonly property int typeFetchMoreTrigger: 2

    readonly property bool isFetchMoreTrigger: model.type === typeFetchMoreTrigger
    readonly property bool isCategorySeparator: model.type === typeCategorySeparator

    enabled: !isCategorySeparator
    hoverEnabled: !isCategorySeparator

    height: !isCategorySeparator ? defaultHeight : defaultHeight/2
    
    Rectangle {
        id: unifiedSearchResultHoverBackground
        anchors.fill: parent
        color: (parent.containsMouse ? Style.lightHover : "transparent")
    }

    RowLayout {
        id: unifiedSearchResultItemDetails

        visible: !isFetchMoreTrigger && !isCategorySeparator

        anchors.fill: parent
        anchors.leftMargin: contentLeftMargin
        anchors.rightMargin: contentRightMargin

        spacing: 0

        Accessible.role: Accessible.ListItem
        Accessible.name: resultTitle
        Accessible.onPressAction: unifiedSearchResultMouseArea.clicked()

        ColumnLayout {
            id: unifiedSearchResultLeftColumn
            visible: model.thumbnailUrl || model.thumbnailUrlLocal
            Layout.preferredWidth: visible ? Layout.preferredHeight : 0
            Layout.preferredHeight: visible ? Style.trayWindowHeaderHeight : 0
            Image {
                id: unifiedSearchResultThumbnail
                visible: !unifiedSearchResultThumbnailPlaceholder.visible
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                verticalAlignment: Qt.AlignCenter
                asynchronous: true
                cache: true
                source: model.thumbnailUrlLocal ? model.thumbnailUrlLocal : "image://unified-search-result-image/" + model.thumbnailUrl
                sourceSize.width: visible ? Style.trayWindowHeaderHeight : 0
                sourceSize.height: visible ? Style.trayWindowHeaderHeight : 0
                Layout.preferredWidth: visible ? Layout.preferredHeight : 0
                Layout.preferredHeight: visible ? Style.trayWindowHeaderHeight : 0
            }
            /*OpacityMask {
                anchors.fill: unifiedSearchResultThumbnail
                source: unifiedSearchResultThumbnail.status == Image.Ready ? unifiedSearchResultThumbnail : null
                maskSource: Rectangle {
                    width: unifiedSearchResultThumbnail.width
                    height: unifiedSearchResultThumbnail.height
                    radius: 25
                    visible: false // this also needs to be invisible or it will cover up the image
                }
            }*/
            Image {
                id: unifiedSearchResultThumbnailPlaceholder
                visible: !model.thumbnailUrlLocal && model.thumbnailUrl && unifiedSearchResultThumbnail.status != Image.Ready
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                verticalAlignment: Qt.AlignCenter
                cache: true
                source: "qrc:///client/theme/change.svg"
                sourceSize.height: Style.trayWindowHeaderHeight
                sourceSize.width: Style.trayWindowHeaderHeight
                Layout.preferredWidth: visible ? Layout.preferredHeight : 0
                Layout.preferredHeight: visible ? Style.trayWindowHeaderHeight : 0
            }
        }

        ColumnLayout {
            id: unifiedSearchResultRightColumn
            Layout.fillWidth: true

            Text {
                id: unifiedSearchResultTitleText
                text: model.resultTitle.replace(/[\r\n]+/g, " ")
                visible: parent.visible
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: Style.topLinePixelSize
                color: "black"
            }
            Text {
                id: unifiedSearchResultTextSubline
                text: model.subline.replace(/[\r\n]+/g, " ")
                elide: Text.ElideRight
                visible: parent.visible
                Layout.fillWidth: true
                color: "grey"
            }
        }

    }

    RowLayout {
        id: unifiedSearchResultItemFetchMore
        visible: isFetchMoreTrigger

        width: visible ? unifiedSearchResultMouseArea.width : 0
        height: visible ? Style.trayWindowHeaderHeight : 0

        Accessible.role: Accessible.ListItem
        Accessible.name: qsTr("Load more results")
        Accessible.onPressAction: unifiedSearchResultMouseArea.clicked()

        Column {
            id: unifiedSearchResultItemFetchMoreColumn
            visible: isFetchMoreTrigger
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: unifiedSearchResultItemFetchMoreText
                text: qsTr("Load more results")
                visible: parent.visible
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: parent.width
                height: parent.height
                font.pixelSize: Style.topLinePixelSize
                color: "grey"
            }
        }
    }

    RowLayout {
        id: unifiedSearchResultItemCategorySeparator
        visible: isCategorySeparator

        width: visible ? unifiedSearchResultMouseArea.width : 0

        Accessible.role: Accessible.ListItem
        Accessible.name: qsTr("Category separator")
        Accessible.onPressAction: unifiedSearchResultMouseArea.clicked()

        Column {
            id: unifiedSearchResultItemCategorySeparatorColumn
            visible: isCategorySeparator
            Layout.topMargin: 8
            Layout.leftMargin: contentLeftMargin
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            Text {
                id: unifiedSearchResultItemCategorySeparatorText
                text: model.categoryName
                visible: parent.visible
                width: parent.width
                height: parent.height
                font.pixelSize: Style.topLinePixelSize
                color: Style.ncBlue
            }
        }
    }
}
