attribute vec3 aPos;
attribute vec2 aTexCoord;

varying lowp vec2 TexCoord;

void main()
{
    TexCoord = aTexCoord;
//    gl_Position = vec4(aPos.x, aPos.y, 0.0, 1.0);
    gl_Position = vec4(aPos.x,-aPos.y,aPos.z,1.0);
}
