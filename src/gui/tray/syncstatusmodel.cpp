#include "syncstatusmodel.h"
#include "folderman.h"
#include "navigationpanehelper.h"
#include <qnamespace.h>

namespace OCC {

SyncStatusModel::SyncStatusModel(QObject *parent)
    : QObject(parent)
{
    const auto folderMan = FolderMan::instance();

    connect(folderMan, &FolderMan::folderListChanged,
        this, &SyncStatusModel::onFolderListChanged);

    for (const auto &folder : folderMan->map()) {
        connect(folder, &Folder::progressInfo, this, &SyncStatusModel::onFolderProgressInfo, Qt::UniqueConnection);
    }
}

double SyncStatusModel::syncProgress() const
{
    return _progress;
}

void SyncStatusModel::onFolderListChanged(const OCC::Folder::Map &folderMap)
{
    for (const auto &folder : folderMap) {
        connect(folder, &Folder::progressInfo, this, &SyncStatusModel::onFolderProgressInfo, Qt::UniqueConnection);
    }
}

void SyncStatusModel::onFolderProgressInfo(const ProgressInfo &progress)
{
    const qint64 completedSize = progress.completedSize();
    const qint64 currentFile = progress.currentFile();
    const qint64 completedFile = progress.completedFiles();
    const qint64 totalSize = qMax(completedSize, progress.totalSize());
    const qint64 totalFileCount = qMax(currentFile, progress.totalFiles());

    int overallPercent = 0;
    if (totalFileCount > 0) {
        // Add one 'byte' for each file so the percentage is moving when deleting or renaming files
        overallPercent = qRound(double(completedSize + completedFile) / double(totalSize + totalFileCount) * 100.0);
    }
    overallPercent = qBound(0, overallPercent, 100);


    const auto result = overallPercent / 100.0;
    if (result == _progress) {
        return;
    }

    _progress = result;
    emit syncProgressChanged();
}
}


