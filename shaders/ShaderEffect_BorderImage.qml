import QtQuick 2.0

Item {

    id: root

    width: 600
    height: 400

    property string imageName: "tinytile.png"
    property int border: 3


    Row {
        id: row

        property real cellWidth: (width - spacing) / 2;

        spacing: 10
        anchors.fill: parent
        anchors.margins: 10

        BorderImage {
            id: borderImage

            width: row.cellWidth
            height: parent.height

            source: root.imageName
            border { left: root.border; right: root.border; top: root.border; bottom: root.border }

            horizontalTileMode: BorderImage.Repeat
            verticalTileMode: BorderImage.Repeat
        }

        ShaderEffect {
            id: shader

            width: row.cellWidth
            height: parent.height

            property variant source: Image { source: root.imageName }

            // x, y, width, height
            property variant isrect: Qt.rect(root.border / source.width,
                                             root.border / source.height,
                                             (source.width - 2 * root.border) / source.width,
                                             (source.height - 2 * root.border) / source.height);

            property variant iSourceSize: Qt.point(1 / source.width, 1 / source.height);

            // left, top, right, bottom
            property variant itrect: Qt.rect(root.border / width,
                                            root.border / height,
                                            (width - root.border) / width,
                                            (height - root.border) / height);

            property variant textureStep: Qt.point(width / source.width, height / source.height);

            onItrectChanged: print("itrect", itrect, "width: " + width, "height: " + height);

            vertexShader:
                "
                attribute highp vec4 qt_Vertex;
                attribute highp vec2 qt_MultiTexCoord0;
                uniform mat4 qt_Matrix;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    gl_Position = qt_Matrix * qt_Vertex;
                    qt_TexCoord0 = qt_MultiTexCoord0;
                }
                "


            /*

              qt_TexCoord0.x = 0                                                            qt_TexCoord0.x = 1
                                    itrect.x                        itrect.z
                  pixel-to-pixel                 tiled                  pixel-to-pixel
              |                     |                               |                       |

              */


            fragmentShader:
                "
                uniform lowp sampler2D source;
                uniform highp vec4 itrect;
                uniform highp vec4 isrect;
                uniform highp vec2 iSourceSize;
                uniform highp vec2 textureStep;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    highp vec2 tl = qt_TexCoord0 * textureStep;
                    highp vec2 br = isrect.xy + isrect.zw + (qt_TexCoord0 - itrect.zw) * textureStep;
                    highp vec2 c = isrect.xy + iSourceSize * 0.5 + mod((qt_TexCoord0 - itrect.xy) * textureStep, isrect.zw) * (1.0 - iSourceSize);

                    highp vec2 tcoord = c;

                    if (qt_TexCoord0.x < itrect.x)
                        tcoord.x = tl.x;
                    else if (qt_TexCoord0.x > itrect.z)
                        tcoord.x = br.x;

                    if (qt_TexCoord0.y < itrect.y)
                        tcoord.y = tl.y;
                    else if (qt_TexCoord0.y > itrect.w)
                        tcoord.y = br.y;

                    gl_FragColor = texture2D(source, tcoord);

                }
                "
        }

    }



}
