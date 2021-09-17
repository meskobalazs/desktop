import QtQml 2.12
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import Style 1.0
import com.nextcloud.desktopclient 1.0

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

        width: visible ? unifiedSearchResultMouseArea.width : 0
        height: visible ? Style.trayWindowHeaderHeight : 0

        spacing: 0

        Accessible.role: Accessible.ListItem
        Accessible.name: resultTitle
        Accessible.onPressAction: unifiedSearchResultMouseArea.clicked()

        ColumnLayout {
            id: unifiedSearchResultLeftColumn
            Layout.preferredWidth: visible ? Layout.preferredHeight : 0
            Layout.preferredHeight: visible ? previewThumbnailHeight : 0
            visible: model.thumbnailUrl
            Image {
                id: unifiedSearchResultThumbnail
                visible: !unifiedSearchResultThumbnailPlaceholder.visible
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                verticalAlignment: Qt.AlignCenter
                asynchronous: true
                cache: true
                source: "image://unified-search-result-image/" + model.thumbnailUrl
                sourceSize.width: sourceSize.height
                sourceSize.height: previewThumbnailHeight
            }
            Image {
                id: unifiedSearchResultThumbnailPlaceholder
                visible: model.thumbnailUrl && unifiedSearchResultThumbnail.status != Image.Ready
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                verticalAlignment: Qt.AlignCenter
                asynchronous: true
                cache: true
                source: "qrc:///client/theme/change.svg"
                sourceSize.height: Style.trayWindowHeaderHeight
                sourceSize.width: height
            }
        }

        Column {
            id: unifiedSearchResultRightColumn
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 8
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            spacing: 4
            ColumnLayout {
                spacing: 2
                Rectangle {
                    Layout.preferredHeight: Style.trayWindowHeaderHeight / 2
                    Layout.fillWidth: true

                    Text {
                        id: unifiedSearchResultTitleText
                        text: model.resultTitle
                        visible: parent.visible
                        width: parent.width
                        font.pixelSize: Style.topLinePixelSize
                        color: "black"
                    }
                }
                Rectangle {
                    Layout.preferredHeight: Style.trayWindowHeaderHeight / 2
                    Layout.fillWidth: true
                    Text {
                        id: unifiedSearchResultTextSubline
                        text: model.subline
                        visible: parent.visible
                        width: parent.width
                        font.pixelSize: Style.subLinePixelSize
                        color: "grey"
                    }
                }
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
