varying lowp vec2 TexCoord;//纹理坐标
uniform sampler2D LumaY;//明亮度
uniform sampler2D ChrominanceU;//色度
uniform sampler2D ChromaV;//饱和度

void main()
{
    //方式一：yuv转rgb
//    highp float y = texture2D(LumaY, TexCoord).r;
//    highp float u = texture2D(ChrominanceU, TexCoord).r - 0.5;
//    highp float v = texture2D(ChromaV, TexCoord).r - 0.5;
//
//    highp float r = y +             1.402 * v;
//    highp float g = y - 0.344 * u - 0.714 * v;
//    highp float b = y + 1.772 * u;
//
//    gl_FragColor = vec4(r,g,b,1.0);
    
    
    //方式二：
    mediump vec3 yuv;
    lowp vec3 rgb;
    yuv.x = texture2D(LumaY, TexCoord).r;
    yuv.y = texture2D(ChrominanceU, TexCoord).r - 0.5;
    yuv.z = texture2D(ChromaV, TexCoord).r - 0.5;
    rgb = mat3( 1,   1,   1,
    0,       -0.39465,  2.03211,
    1.13983,   -0.58060,  0) * yuv;
    gl_FragColor = vec4(rgb, 1);
}
