varying lowp vec2 TexCoord;
uniform sampler2D screenTexture;

void main()
{
//    gl_FragColor = texture2D(screenTexture, TexCoord);//只显示图片
    gl_FragColor = vec4(vec3(1.0 - texture2D(screenTexture, TexCoord)), 1.0);

}
