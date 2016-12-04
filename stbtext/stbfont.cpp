#include "stbfont.h"

#include <QtCore/QElapsedTimer>

#include <QtQuick/QQuickWindow>
#include <QtQuick/QSGNode>
#include <QtQuick/QSGGeometry>
#include <QtQuick/QSGSimpleMaterialShader>

#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"

class StbFontTexture : public QSGTexture
{
public:
    int textureId() const Q_DECL_OVERRIDE { return m_id; }
    QSize textureSize() const Q_DECL_OVERRIDE { return m_size; }
    bool hasAlphaChannel() const Q_DECL_OVERRIDE { return false; }
    bool hasMipmaps() const Q_DECL_OVERRIDE { return false; }
    void bind() Q_DECL_OVERRIDE { glBindTexture(GL_TEXTURE_2D, m_id); }
    QSize m_size;
    GLuint m_id;
};

struct StbFontShaderState
{
    QSGTexture *texture;
};

class StbFontShader : public QSGSimpleMaterialShader<StbFontShaderState>
{
    QSG_DECLARE_SIMPLE_SHADER(StbFontShader, StbFontShaderState)
public:

    const char *vertexShader() const Q_DECL_OVERRIDE {
        return
        "attribute highp vec4 aV;                           \n"
        "attribute highp vec2 aT;                           \n"
        "attribute lowp vec4 aC;                            \n"
        "uniform highp mat4 qt_Matrix;                      \n"
        "varying highp vec2 vT;                             \n"
        "varying lowp vec4 vC;                              \n"
        "void main() {                                      \n"
        "    gl_Position = qt_Matrix * aV;                  \n"
        "    vT = aT / 512.0;                               \n"
        "    vC = aC;                                       \n"
        "}";
    }

    const char *fragmentShader() const Q_DECL_OVERRIDE {
        return
        "uniform lowp float qt_Opacity;                     \n"
        "uniform lowp sampler2D sampler;                    \n"
        "varying highp vec2 vT;                             \n"
        "varying lowp vec4 vC;                              \n"
        "void main() {                                      \n"
        "    lowp float a = texture2D(sampler, vT).a;       \n"
        "    gl_FragColor = vC * (a * qt_Opacity);          \n"
        "}";
    }

    QList<QByteArray> attributes() const Q_DECL_OVERRIDE {
        return QList<QByteArray>() << "aV" << "aT" << "aC";
    }

    void updateState(const StbFontShaderState *state, const StbFontShaderState *) Q_DECL_OVERRIDE
    {
        state->texture->bind();
    }

};

struct StbGlyphVertex
{
    float x, y;
    float tx, ty;
    unsigned char r, g, b, a;

    void set(float x, float y, float tx, float ty, unsigned char r, unsigned char g, unsigned char b, unsigned char a, float idpr)
    {
        this->x = x * idpr;
        this->y = y * idpr;
        this->tx = tx;
        this->ty = ty;
        this->r = r;
        this->g = g;
        this->b = b;
        this->a = a;
    }

};

static QSGGeometry::Attribute StbFont_Attributes[] = {
    QSGGeometry::Attribute::create(0, 2, GL_FLOAT, true),
    QSGGeometry::Attribute::create(1, 2, GL_FLOAT, false),
    QSGGeometry::Attribute::create(2, 4, GL_UNSIGNED_BYTE, false)
};

static QSGGeometry::AttributeSet StbFont_AttributeSet = {
    3,                                                                 // attribute count
    2 * sizeof(float) + 2 * sizeof(float) + 4 * sizeof(unsigned char), // stride
    StbFont_Attributes
};



StbFont::StbFont()
    : m_size(12)
    , m_texture(0)
    , m_tryLoad(false)
{
}

void StbFont::setFont(const QString &font)
{
    if (m_font == font)
        return;
    m_font = font;
    emit fontChanged();
    m_tryLoad = true;
}

void StbFont::setSize(float size)
{
    if (m_size == size)
        return;
    m_size = size;
    emit sizeChanged();
    m_tryLoad = true;
}

QSGNode *StbFont::update(QSGNode *old, const QString &text)
{
    if (m_tryLoad)
        loadFont();

    QElapsedTimer timer;
    timer.start();

    int glyphCount = 0;
    for (int i=0; i<text.size(); ++i) {
        if (!text.at(i).isSpace())
            ++glyphCount;
    }

    int vertexCount = glyphCount * 4;
    int indexCount = glyphCount * 6;

    if (indexCount == 0) {
        delete old;
        return 0;
    }

    QSGGeometryNode *node = static_cast<QSGGeometryNode *>(old);
    if (!node) {
        node = new QSGGeometryNode();
        QSGGeometry *g = new QSGGeometry(StbFont_AttributeSet, vertexCount, indexCount);
        g->setDrawingMode(GL_TRIANGLES);
        node->setGeometry(g);
        node->setFlag(QSGNode::OwnsGeometry, true);
        QSGSimpleMaterial<StbFontShaderState> *material = StbFontShader::createMaterial();
        material->setFlag(QSGMaterial::Blending);
        node->setMaterial(material);
        node->setFlag(QSGNode::OwnsMaterial, true);

    }

    float idpr = 1.0f / window()->effectiveDevicePixelRatio();

    QSGSimpleMaterial<StbFontShaderState> *material = static_cast<QSGSimpleMaterial<StbFontShaderState> *>(node->material());
    material->state()->texture = m_texture;

    QSGGeometry *g = node->geometry();

    // g->setDrawingMode(GL_TRIANGLE_STRIP);
    // g->allocate(4, 0);
    // StbGlyphVertex *vd = (StbGlyphVertex *) g->vertexData();
    // vd[0].set(  0,   0,     0,   0,   0, 0, 0, 255);
    // vd[1].set(200,   0,   512,   0,   0, 0, 0, 255);
    // vd[2].set(  0, 200,     0, 512,   0, 0, 0, 255);
    // vd[3].set(200, 200,   512, 512,   0, 0, 0, 255);

    g->allocate(vertexCount, indexCount);

    StbGlyphVertex *vd = (StbGlyphVertex *) g->vertexData();
    quint16 *id = g->indexDataAsUShort();

    // ### hardcoded size...
    QSize tSize = m_texture->textureSize();
    float txs = 1 / tSize.width();
    float tys = 1 / tSize.height();

    float x = 0;
    float y = 0;

    int glyphIndex = 0;

    for (int i=0; i<text.size(); ++i) {
        if (!text.at(i).isSpace()) {
            int uc = text.at(i).unicode();
            if (uc > 96 + 32) {
                // out of our fixed range..
                qFatal("uh oh...");
            }

            const stbtt_bakedchar &c = ((const stbtt_bakedchar *) m_bakedChars.data())[uc - 32];
            // qDebug(" - %d: %d, tex=[%d, %d, %d, %d], off=[%f, %f], advance=%f",
            //        i, uc,
            //        (int) c.x0, (int) c.y0, (int) c.x1, (int) c.y1,
            //        c.xoff, c.yoff,
            //        c.xadvance);

            float w = c.x1 - c.x0;
            float h = c.y1 - c.y0;

            vd[0].set(  x + c.xoff, y + m_size + c.yoff,   c.x0, c.y0,   0, 0, 0, 255, idpr);
            vd[1].set(x+w + c.xoff, y + m_size + c.yoff,   c.x1, c.y0,   0, 0, 0, 255, idpr);
            vd[2].set(  x + c.xoff, y+h + m_size + c.yoff, c.x0, c.y1,   0, 0, 0, 255, idpr);
            vd[3].set(x+w + c.xoff, y+h + m_size + c.yoff, c.x1, c.y1,   0, 0, 0, 255, idpr);
            vd += 4;

            id[0] = 0 + glyphIndex;
            id[1] = 1 + glyphIndex;
            id[2] = 2 + glyphIndex;

            id[3] = 2 + glyphIndex;
            id[4] = 1 + glyphIndex;
            id[5] = 3 + glyphIndex;
            id += 6;
            glyphIndex += 4;

            x += c.xadvance;
        }
    }

    // qDebug("StbFont: node for %d glyphs created in %.3fms", glyphCount, timer.nsecsElapsed() / 1000000.0);

    return node;
}

bool StbFont::loadFont()
{
    QElapsedTimer timer; timer.start();

    m_tryLoad = false;

    QFile file(m_font);
    if (!file.open(QFile::ReadOnly))
        return false;

    QByteArray pixelData;
    int tw = 512;
    int th = 512;
    pixelData.fill(0, tw * th);

    int glyphCount = 96;
    m_bakedChars.resize(glyphCount * sizeof(stbtt_bakedchar));

    m_fontData = file.readAll();
    stbtt_BakeFontBitmap((unsigned char *) m_fontData.data(), 0,     // font and offset, which is 0
                         m_size,                                     // pixel size
                         (unsigned char *) pixelData.data(), tw, th, // texture data, width and height
                         32, glyphCount,                             // first char, num_chars
                         (stbtt_bakedchar *) m_bakedChars.data());   // baked char data

    // QImage image((unsigned char *) pixelData.data(), tw, th, QImage::Format_Grayscale8);
    // image.save("atlas.png");

    StbFontTexture *tex = new StbFontTexture();
    glGenTextures(1, &tex->m_id);
    glBindTexture(GL_TEXTURE_2D, tex->m_id);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, tw, th, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pixelData.data());
    m_texture = tex;

    // qDebug("StbFont: font '%s' was reloaded in %.3fms", qPrintable(m_font), timer.nsecsElapsed() / 1000000.0);

    return true;
}
