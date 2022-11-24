#ifndef XMLHANDLER_H
#define XMLHANDLER_H

#include <QObject>
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"
class xmlHandler : public QObject
{
    Q_OBJECT
public:
    explicit xmlHandler(QObject *parent = nullptr);
    xmlHandler(QString file);
    QDomDocument parserApplicationList(QList<ApplicationItem> apps);
    Q_INVOKABLE void writeXMLFile(ApplicationsModel appsModel);

    Q_INVOKABLE void save(int index, QString title, QString icon, QString url, int oldIndex);
private:
    QString m_file;
};

#endif // XMLHANDLER_H
