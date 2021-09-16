#pragma once

#include <folder.h>

#include <QObject>

namespace OCC {

class SyncStatusModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double syncProgress READ syncProgress NOTIFY syncProgressChanged)
    Q_PROPERTY(QUrl syncIcon READ syncIcon NOTIFY syncIconChanged)
    Q_PROPERTY(bool syncing READ syncing NOTIFY syncingChanged)

public:
    explicit SyncStatusModel(QObject *parent = nullptr);

    double syncProgress() const;
    QUrl syncIcon() const;
    bool syncing() const;

signals:
    void syncProgressChanged();
    void syncIconChanged();
    void syncingChanged();

private:
    void onFolderListChanged(const OCC::Folder::Map &folderMap);
    void onFolderProgressInfo(const ProgressInfo &progress);
    void setSyncing(bool value);

    double _progress = 1.0;
    bool _isSyncing = false;
};
}
