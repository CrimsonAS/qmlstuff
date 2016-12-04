#pragma once

#include <QtQuick/QQuickItem>
#include <QtCore/QString>

#include "stbfont.h"

class StbText : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(StbFont *font READ font WRITE setFont NOTIFY fontChanged)

public:
    StbText();

    QString text() const { return m_text; }
    void setText(const QString &text);

    StbFont *font() const { return m_font; }
    void setFont(StbFont *font);

protected:
    QSGNode *updatePaintNode(QSGNode *old, UpdatePaintNodeData *);

signals:
    void textChanged();
    void fontChanged();

private:
    StbFont *m_font;
    QString m_text;
};

