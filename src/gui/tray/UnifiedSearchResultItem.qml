import QtQml 2.12
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import Style 1.0
import com.nextcloud.desktopclient 1.0
import QtGraphicalEffects 1.0
MouseArea {
    id: unifiedSearchResultMouseArea
    enabled: !model.isCategorySeparator
    hoverEnabled: !model.isCategorySeparator
    
    Rectangle {
        anchors.fill: parent
        color: (parent.containsMouse ? Style.lightHover : "transparent")
    }

    RowLayout {
        id: unifiedSearchResultItemDetails

        readonly property int previewThumbnailHeight: unifiedSearchResultMouseArea.height

        visible: !model.isFetchMoreTrigger && !model.isCategorySeparator

        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8

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
                property bool rounded: true
                    property bool adapt: true
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

            TextMetrics {
                id: textMetricsResultTitle
                elide: Text.ElideRight
                elideWidth: 150
                font.pixelSize: Style.subLinePixelSize
                text: model.resultTitle
            }

            Text {
                id: unifiedSearchResultTitleText
                text: textMetricsResultTitle.elidedText
                visible: parent.visible
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: Style.topLinePixelSize
                color: "black"
            }
            TextMetrics {
                id: textMetricsSubline
                elide: Text.ElideRight
                elideWidth: 150
                font.pixelSize: Style.subLinePixelSize
                text: model.subline
            }
            Text {
                id: unifiedSearchResultTextSubline
                text: textMetricsSubline.elidedText
                visible: parent.visible
                Layout.fillWidth: true
                color: "grey"
            }
        }

    }

    RowLayout {
        id: unifiedSearchResultItemFetchMore
        visible: model.isFetchMoreTrigger

        width: visible ? unifiedSearchResultMouseArea.width : 0
        height: visible ? Style.trayWindowHeaderHeight : 0

        Accessible.role: Accessible.ListItem
        Accessible.name: qsTr("Load more results")
        Accessible.onPressAction: unifiedSearchResultMouseArea.clicked()

        Column {
            id: unifiedSearchResultItemFetchMoreColumn
            visible: model.isFetchMoreTrigger
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
        visible: model.isCategorySeparator

        width: visible ? unifiedSearchResultMouseArea.width : 0
        height: visible ? Style.trayWindowHeaderHeight : 0
        spacing: 2

        Accessible.role: Accessible.ListItem
        Accessible.name: qsTr("Category separator")
        Accessible.onPressAction: unifiedSearchResultMouseArea.clicked()

        Column {
            id: unifiedSearchResultItemCategorySeparatorColumn
            visible: model.isCategorySeparator
            Layout.leftMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            Layout.alignment: Qt.AlignLeft

            Text {
                id: unifiedSearchResultItemCategorySeparatorText
                text: model.categoryName
                visible: parent.visible
                width: parent.width
                font.pixelSize: Style.topLinePixelSize * 1.5
                color: Style.ncBlue
            }
        }
    }
}
