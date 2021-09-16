/*
 * Copyright (C) by Camila Ayres <hello@camila.codes>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 */

#include "iconjob.h"

namespace OCC {

IconJob::IconJob(AccountPtr account, const QUrl &url, QObject *parent)
    : AbstractNetworkJob(account, QString(), parent)
    , _iconUrl(url)
{
}

void IconJob::start()
{
    sendRequest("GET", _iconUrl);
    AbstractNetworkJob::start();
}

bool IconJob::finished()
{
    emit jobFinished(reply()->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(), reply()->readAll());
    return true;
}
}
