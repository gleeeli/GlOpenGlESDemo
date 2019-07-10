varying lowp vec2 TexCoord;
uniform sampler2D rgbTexture;

void main()
{
    gl_FragColor = vec4(vec3(1.0 - texture2D(rgbTexture, TexCoord)), 1.0);
}
