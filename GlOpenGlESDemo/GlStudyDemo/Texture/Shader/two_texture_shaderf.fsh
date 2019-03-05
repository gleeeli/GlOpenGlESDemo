varying lowp vec2 TexCoord;
uniform sampler2D ourTexture;

uniform sampler2D texture1;
uniform sampler2D texture2;

void main()
{
    //0.2会返回80%的第一个输入颜色和20%的第二个输入颜色，即返回两个纹理的混合色。
    //1.0 - TexCoord 是为了图片倒转过来，图片的y轴默认是反的
    gl_FragColor = mix(texture2D(texture1, 1.0 - TexCoord), texture2D(texture2, 1.0 - TexCoord), 0.2);
}
