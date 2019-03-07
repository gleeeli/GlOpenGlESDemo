attribute vec3 aPos;
attribute vec2 aTexCoord;

varying lowp vec2 TexCoord;

uniform mat4 transform;//变换矩阵

void main()
{
    gl_Position = transform * vec4(aPos, 1.0);
    TexCoord = vec2(aTexCoord.x, 1.0 - aTexCoord.y);
}
