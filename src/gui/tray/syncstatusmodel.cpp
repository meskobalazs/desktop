#include "syncstatusmodel.h"
#include "folderman.h"
#include "navigationpanehelper.h"
#include "syncresult.h"
#include "theme.h"
#include <qnamespace.h>

namespace OCC {

SyncStatusModel::SyncStatusModel(QObject *parent)
    : QObject(parent)
{
    const auto folderMan = FolderMan::instance();

    connect(folderMan, &FolderMan::folderListChanged,
        this, &SyncStatusModel::onFolderListChanged);
    connect(folderMan, &FolderMan::folderSyncStateChange,
        this, &SyncStatusModel::onFolderSyncStateChanged);

    for (const auto &folder : folderMan->map()) {
        connect(folder, &Folder::progressInfo, this, &SyncStatusModel::onFolderProgressInfo, Qt::UniqueConnection);
    }
}

double SyncStatusModel::syncProgress() const
{
    return _progress;
}

QUrl SyncStatusModel::syncIcon() const
{
    return _syncIcon;
}

bool SyncStatusModel::syncing() const
{
    return _isSyncing;
}

void SyncStatusModel::onFolderListChanged(const OCC::Folder::Map &folderMap)
{
    for (const auto &folder : folderMap) {
        connect(folder, &Folder::progressInfo, this, &SyncStatusModel::onFolderProgressInfo, Qt::UniqueConnection);
    }
}

void SyncStatusModel::onFolderSyncStateChanged(const Folder *folder)
{
    if (!folder) {
        return;
    }

    switch (folder->syncResult().status()) {
    case SyncResult::Success:
        setSyncing(false);
        setSyncStatusString(_syncStatusStringSynced);
        setSyncIcon(Theme::instance()->syncStatusOk());
        break;
    case SyncResult::Error:
        setSyncing(false);
        setSyncStatusString(_syncStatusStringError);
        setSyncIcon(Theme::instance()->syncStatusError());
        break;
    case SyncResult::SyncRunning:
        setSyncing(true);
        setSyncStatusString(_syncStatusStringSyncing);
        setSyncIcon(Theme::instance()->syncStatusRunning());
        break;
    case SyncResult::Undefined:
    case SyncResult::NotYetStarted:
    case SyncResult::Problem:
    case SyncResult::Paused:
    case SyncResult::SyncPrepare:
    case SyncResult::SyncAbortRequested:
    case SyncResult::SetupError:
        break;
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
    setProgress(result);

    // Calculate sync string
    QString overallSyncString;
    if (totalSize > 0) {
        QString s1 = Utility::octetsToString(completedSize);
        QString s2 = Utility::octetsToString(totalSize);

        if (progress.trustEta()) {
            //: Example text: "5 minutes left, 12 MB of 345 MB, file 6 of 7"
            overallSyncString = tr("%5 left, %1 of %2, file %3 of %4")
                                    .arg(s1, s2)
                                    .arg(currentFile)
                                    .arg(totalFileCount)
                                    .arg(Utility::durationToDescriptiveString1(progress.totalProgress().estimatedEta));

        } else {
            //: Example text: "12 MB of 345 MB, file 6 of 7"
            overallSyncString = tr("%1 of %2, file %3 of %4")
                                    .arg(s1, s2)
                                    .arg(currentFile)
                                    .arg(totalFileCount);
        }
    } else if (totalFileCount > 0) {
        // Don't attempt to estimate the time left if there is no kb to transfer.
        overallSyncString = tr("file %1 of %2").arg(currentFile).arg(totalFileCount);
    }
    setSyncString(overallSyncString);
}

void SyncStatusModel::setSyncing(bool value)
{
    if (value == _isSyncing) {
        return;
    }

    _isSyncing = value;
    emit syncingChanged();
}

QString SyncStatusModel::syncString() const
{
    return _syncString;
}

void SyncStatusModel::setSyncString(const QString &value)
{
    if (_syncString == value) {
        return;
    }

    _syncString = value;
    emit syncStringChanged();
}

void SyncStatusModel::setProgress(double value)
{
    if (_progress == value) {
        return;
    }

    _progress = value;
    emit syncProgressChanged();
}

void SyncStatusModel::setSyncStatusString(const QString& value)
{
    if (_syncStatusString == value) {
        return;
    }

    _syncStatusString = value;
    emit syncStatusStringChanged();
}

QString SyncStatusModel::syncStatusString() const
{
    return _syncStatusString;
}
 
void SyncStatusModel::setSyncIcon(const QUrl &value)
{
    if (_syncIcon == value) {
        return;
    }

    _syncIcon = value;
    emit syncIconChanged();
}

}


