#pragma once

#include <folder.h>

#include <QObject>

namespace OCC {

class SyncStatusModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double syncProgress READ syncProgress NOTIFY syncProgressChanged)

public:
    explicit SyncStatusModel(QObject *parent = nullptr);

    double syncProgress() const;

signals:
    void syncProgressChanged();

private:
    void onFolderListChanged(const OCC::Folder::Map &folderMap);
    void onFolderProgressInfo(const ProgressInfo &progress);

    double _progress = 1.0;
};
}
