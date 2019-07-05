varying lowp vec2 TexCoord;
uniform sampler2D u_Texture;

void main()
{
//    lowp vec3 col = texture2D(screenTexture, TexCoord).rgb;
//    gl_FragColor = vec4(col, 1.0);
    gl_FragColor = texture2D(u_Texture, TexCoord);//只显示图片
}
