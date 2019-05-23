attribute vec3 aPos;
attribute vec3 aNormal;//顶点数组输入 法向量

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

varying lowp vec3 Normal;//输出变量 法向量
varying lowp vec3 FragPos;//输出变量 世界空间位置

//逆矩阵(Inverse Matrix) GLSL3.0 可以使用内置函数inverse
mat4 inverse_mat4(mat4 m)
{
    float Coef00 = m[2][2] * m[3][3] - m[3][2] * m[2][3];
    float Coef02 = m[1][2] * m[3][3] - m[3][2] * m[1][3];
    float Coef03 = m[1][2] * m[2][3] - m[2][2] * m[1][3];
    
    float Coef04 = m[2][1] * m[3][3] - m[3][1] * m[2][3];
    float Coef06 = m[1][1] * m[3][3] - m[3][1] * m[1][3];
    float Coef07 = m[1][1] * m[2][3] - m[2][1] * m[1][3];
    
    float Coef08 = m[2][1] * m[3][2] - m[3][1] * m[2][2];
    float Coef10 = m[1][1] * m[3][2] - m[3][1] * m[1][2];
    float Coef11 = m[1][1] * m[2][2] - m[2][1] * m[1][2];
    
    float Coef12 = m[2][0] * m[3][3] - m[3][0] * m[2][3];
    float Coef14 = m[1][0] * m[3][3] - m[3][0] * m[1][3];
    float Coef15 = m[1][0] * m[2][3] - m[2][0] * m[1][3];
    
    float Coef16 = m[2][0] * m[3][2] - m[3][0] * m[2][2];
    float Coef18 = m[1][0] * m[3][2] - m[3][0] * m[1][2];
    float Coef19 = m[1][0] * m[2][2] - m[2][0] * m[1][2];
    
    float Coef20 = m[2][0] * m[3][1] - m[3][0] * m[2][1];
    float Coef22 = m[1][0] * m[3][1] - m[3][0] * m[1][1];
    float Coef23 = m[1][0] * m[2][1] - m[2][0] * m[1][1];
    
    const vec4 SignA = vec4( 1.0, -1.0,  1.0, -1.0);
    const vec4 SignB = vec4(-1.0,  1.0, -1.0,  1.0);
    
    vec4 Fac0 = vec4(Coef00, Coef00, Coef02, Coef03);
    vec4 Fac1 = vec4(Coef04, Coef04, Coef06, Coef07);
    vec4 Fac2 = vec4(Coef08, Coef08, Coef10, Coef11);
    vec4 Fac3 = vec4(Coef12, Coef12, Coef14, Coef15);
    vec4 Fac4 = vec4(Coef16, Coef16, Coef18, Coef19);
    vec4 Fac5 = vec4(Coef20, Coef20, Coef22, Coef23);
    
    vec4 Vec0 = vec4(m[1][0], m[0][0], m[0][0], m[0][0]);
    vec4 Vec1 = vec4(m[1][1], m[0][1], m[0][1], m[0][1]);
    vec4 Vec2 = vec4(m[1][2], m[0][2], m[0][2], m[0][2]);
    vec4 Vec3 = vec4(m[1][3], m[0][3], m[0][3], m[0][3]);
    
    vec4 Inv0 = SignA * (Vec1 * Fac0 - Vec2 * Fac1 + Vec3 * Fac2);
    vec4 Inv1 = SignB * (Vec0 * Fac0 - Vec2 * Fac3 + Vec3 * Fac4);
    vec4 Inv2 = SignA * (Vec0 * Fac1 - Vec1 * Fac3 + Vec3 * Fac5);
    vec4 Inv3 = SignB * (Vec0 * Fac2 - Vec1 * Fac4 + Vec2 * Fac5);
    
    mat4 Inverse = mat4(Inv0, Inv1, Inv2, Inv3);
    
    vec4 Row0 = vec4(Inverse[0][0], Inverse[1][0], Inverse[2][0], Inverse[3][0]);
    
    float Determinant = dot(m[0], Row0);
    
    Inverse /= Determinant;
    
    return Inverse;
}

//转置矩阵(Transpose Matrix) 将横排变成竖屏，3.0版本后可使用内置函数transpose
mat4 czm_transpose(mat4 matrix)
{
    return mat4(
                matrix[0][0], matrix[1][0], matrix[2][0], matrix[3][0],
                matrix[0][1], matrix[1][1], matrix[2][1], matrix[3][1],
                matrix[0][2], matrix[1][2], matrix[2][2], matrix[3][2],
                matrix[0][3], matrix[1][3], matrix[2][3], matrix[3][3]);
}

void main()
{
    
    FragPos = vec3(model * vec4(aPos, 1.0));//变换到世界空间坐标
    
    //不考虑将法线变到世界空间的情况
//    Normal = aNormal;
    
    //我们可以使用inverse和transpose函数自己生成这个法线矩阵
    Normal = mat3(czm_transpose(inverse_mat4(model))) * aNormal;
    
    gl_Position = projection * view  * vec4(FragPos, 1.0);
}

/*
 mat2 czm_transpose(mat2 matrix)
 {
 return mat2(
 matrix[0][0], matrix[1][0],
 matrix[0][1], matrix[1][1]);
 }
 
 mat3 czm_transpose(mat3 matrix)
 {
 return mat3(
 matrix[0][0], matrix[1][0], matrix[2][0],
 matrix[0][1], matrix[1][1], matrix[2][1],
 matrix[0][2], matrix[1][2], matrix[2][2]);
 }
 */
