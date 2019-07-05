attribute vec3 aPos;
attribute vec2 aTexCoord;

varying lowp vec2 TexCoord;

void main()
{
    TexCoord = aTexCoord;
    gl_Position = vec4(aPos,1.0);
}
