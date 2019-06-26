varying lowp vec2 TexCoord;
uniform sampler2D texture1;

void main()
{
    gl_FragColor = texture2D(texture1, TexCoord);//只显示图片
}
