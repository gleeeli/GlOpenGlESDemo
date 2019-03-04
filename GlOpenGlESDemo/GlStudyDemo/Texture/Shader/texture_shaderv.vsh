attribute vec3 aPos;
attribute vec3 aColor;
attribute vec2 aTexCoord;

//varying lowp vec3 ourColor;
varying lowp vec2 TexCoord;

void main()
{
    gl_Position = vec4(aPos,1.0);
//    ourColor = aColor;
    TexCoord = aTexCoord;
}
