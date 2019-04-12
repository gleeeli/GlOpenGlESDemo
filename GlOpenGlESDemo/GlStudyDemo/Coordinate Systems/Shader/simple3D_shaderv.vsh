attribute vec3 aPos;
attribute vec2 aTexCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

//varying lowp vec3 ourColor;//用来顶点颜色与图片混合
varying lowp vec2 TexCoord;

void main()
{
//    gl_Position = vec4(aPos,1.0);
    gl_Position = projection * view * model * vec4(aPos, 1.0);
    TexCoord = vec2(aTexCoord.x, aTexCoord.y);
}
