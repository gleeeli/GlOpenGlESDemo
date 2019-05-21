attribute vec3 aPos;
attribute vec3 aNormal;//顶点数组输入 法向量

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

varying lowp vec3 Normal;//输出变量 法向量
varying lowp vec3 FragPos;//输出变量 世界空间位置

void main()
{
    
    FragPos = vec3(model * vec4(aPos, 1.0));//变换到世界空间坐标
    Normal = aNormal;
    gl_Position = projection * view  * vec4(FragPos, 1.0);
}
