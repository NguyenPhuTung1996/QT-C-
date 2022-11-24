#ifndef XMLREADER_H
#define XMLREADER_H
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"
#include <QObject>
class XmlReader : public QObject
{
    Q_OBJECT
public:
    explicit XmlReader(QObject* parent = nullptr);
    XmlReader(QString filePath, ApplicationsModel &model);



private:
    QDomDocument m_xmlDoc; //The QDomDocument class represents an XML document.
    QString m_filePath;
    ApplicationsModel* m_appmodel;
    bool ReadXmlFile(QString filePath);
    void PaserXml(ApplicationsModel &model);
    QDomDocument parserApplicationList(QList<ApplicationItem> apps);

public slots:
    void writeXMLFile();
};

#endif // XMLREADER_H
