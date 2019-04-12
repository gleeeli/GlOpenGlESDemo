
varying lowp vec2 TexCoord;
uniform sampler2D ourTexture;

//varying lowp vec3 ourColor;//用来顶点颜色与图片混合

void main()
{
        gl_FragColor = texture2D(ourTexture, 1.0 - TexCoord);//只显示图片
//    gl_FragColor = texture2D(ourTexture, TexCoord) * vec4(ourColor, 1.0);//显示图片和顶点颜色的混合
//    gl_FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2);
}
