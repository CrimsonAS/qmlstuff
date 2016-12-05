#pragma once

#include <QtCore/QObject>
#include <QtCore/QString>

#include <QtQuick/QQuickItem>
#include <QtQuick/QSGTexture>

class StbFont : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(float size READ size WRITE setSize NOTIFY sizeChanged)

public:
    StbFont();

    QString font() const { return m_font; }
    void setFont(const QString &font);

    float size() const { return m_size; }
    void setSize(float size);

    QSGNode *update(QSGNode *old, const QString &text, const QColor &color);

signals:
    void fontChanged();
    void sizeChanged();

private:
    bool loadFont();

    QString m_font;
    float m_size;

    QByteArray m_fontData;
    QSGTexture *m_texture;

    QByteArray m_bakedChars;

    uint m_tryLoad : 1;
};