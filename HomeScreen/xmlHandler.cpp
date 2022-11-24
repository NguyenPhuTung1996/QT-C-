#include "xmlHandler.h"
#include <QDebug>
#include <QFile>
#include <QtXml>

xmlHandler::xmlHandler(QObject *parent) : QObject(parent)
{

}

xmlHandler::xmlHandler(QString file)
{
    m_file = file;
}

void xmlHandler::save(int index, QString title, QString icon, QString url, int oldIndex)
{
    QString titleTmp, iconTmp, urlTmp, titleTmp1, iconTmp1, urlTmp1;
    int i = index;
    QDomDocument document;
    QFile xmlFile(m_file);
    if(!xmlFile.open(QIODevice::ReadOnly)){
        qDebug() << "Failed to open file to read";
    }else{
        if(!document.setContent(&xmlFile)){
            qDebug() << "Failed to load file";
        }
        xmlFile.close();
    }

    QDomElement root = document.firstChildElement();
    QDomElement App = root.firstChildElement();

    //tim vt index moi va luu gia tri
    while (!App.isNull()) {
        if (App.attribute("ID") == QString::number(index)){
            QDomElement child = App.firstChildElement();
            while (!child.isNull()) {
                if(child.tagName() == "TITLE"){
                    titleTmp = child.firstChild().toText().data();
                    child.firstChild().toText().setData(title);
                }
                if(child.tagName() == "URL"){
                    urlTmp = child.firstChild().toText().data();
                    child.firstChild().toText().setData(url);
                }
                if(child.tagName() == "ICON_PATH"){
                    iconTmp = child.firstChild().toText().data();
                    child.firstChild().toText().setData(icon);
                }
                child = child.nextSibling().toElement();
            }
            break;
        }
        App = App.nextSibling().toElement();
    }

    if(index < oldIndex){
        while (i < oldIndex) {
            i++;
            App = App.nextSibling().toElement();
            QDomElement child = App.firstChildElement();

                while (!child.isNull()) {
                    if(child.tagName() == "TITLE"){
                        titleTmp1 = child.firstChild().toText().data();
                        child.firstChild().toText().setData(titleTmp);
                        titleTmp = titleTmp1;
                    }
                    if(child.tagName() == "URL"){
                        urlTmp1 = child.firstChild().toText().data();
                        child.firstChild().toText().setData(urlTmp);
                        urlTmp = urlTmp1;
                    }
                    if(child.tagName() == "ICON_PATH"){
                        iconTmp1 = child.firstChild().toText().data();
                        child.firstChild().toText().setData(iconTmp);
                        iconTmp = iconTmp1;
                    }
                    child = child.nextSibling().toElement();
                }
        }
    }


    if(index > oldIndex){
        while (i > oldIndex) {
            i--;
            App = App.previousSibling().toElement();
            QDomElement child = App.firstChildElement();

            while (!child.isNull()) {
                if(child.tagName() == "TITLE"){
                    titleTmp1 = child.firstChild().toText().data();
                    child.firstChild().toText().setData(titleTmp);
                    titleTmp = titleTmp1;
                }
                if(child.tagName() == "URL"){
                    urlTmp1 = child.firstChild().toText().data();
                    child.firstChild().toText().setData(urlTmp);
                    urlTmp = urlTmp1;
                }
                if(child.tagName() == "ICON_PATH"){
                    iconTmp1 = child.firstChild().toText().data();
                    child.firstChild().toText().setData(iconTmp);
                    iconTmp = iconTmp1;
                }
                child = child.nextSibling().toElement();
            }
        }

    }

    if(!xmlFile.open(QIODevice::WriteOnly)){
        qDebug() << "Failed to open file to write";
    }else{
        xmlFile.write(document.toByteArray(5));
        xmlFile.close();
    }

}

void xmlHandler::writeXMLFile(ApplicationsModel appsModel) {

    QString m_file = PROJECT_PATH;
    m_file.append("applications.xml");
    // Convert application list to XML
    QDomDocument document = parserApplicationList(appsModel.getData());

    // Write XML data to file
    QFile file(m_file);
    if( !file.open( QIODevice::WriteOnly | QIODevice::Text ) )
    {
        qDebug( "Failed to open file for writing." );
        qDebug() << "ERROR" << file.errorString() << endl;
    }
    QTextStream stream( &file );
    stream << document.toString();
    file.close();
}

QDomDocument xmlHandler::parserApplicationList(QList<ApplicationItem> apps) {

    int count = 1;

    /********* Create root APPLICATIONS ***********/
    // Create a document to write XML
    QDomDocument document;
    // Making the root element
    QDomElement root = document.createElement("APPLICATIONS");
    // Adding the root element to the docuemnt
    document.appendChild(root);

    /********* Create node of APPLICATIONS ***********/
    foreach (ApplicationItem item , apps) {

        /********* Create node APP ***********/
        // Making the APP element and add
        QDomElement app = document.createElement("APP");
        app.setAttribute("ID", "00" + QString::number(count));
        root.appendChild(app);

        /********* Create child of APP ***********/
        // TITLE
        QDomElement title = document.createElement("TITLE");
        title.appendChild(document.createTextNode(item.title()));
        app.appendChild(title);
        // URL
        QDomElement url = document.createElement("URL");
        url.appendChild(document.createTextNode(item.url()));
        app.appendChild(url);
        // ICON_PATH
        QDomElement icon_path = document.createElement("ICON_PATH");
        icon_path.appendChild(document.createTextNode(item.iconPath()));
        app.appendChild(icon_path);

        count++;
    }

    return document;
}
