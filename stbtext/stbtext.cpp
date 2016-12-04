#include "stbtext.h"

#include <QtQuick/QSGNode>

StbText::StbText()
    : m_font(0)
{
    setFlag(ItemHasContents, true);
}

void StbText::setText(const QString &text)
{
    if (text == m_text)
        return;
    m_text = text;
    emit textChanged();
    update();
}

void StbText::setFont(StbFont *font)
{
    if (m_font == font)
        return;
    m_font = font;
    emit fontChanged();
    update();
}

QSGNode *StbText::updatePaintNode(QSGNode *old, UpdatePaintNodeData *)
{
    if (!m_font) {
        qDebug("StbFont: no 'font' specified...");
        delete old;
        return 0;
    }

    return m_font->update(old, m_text);
}
