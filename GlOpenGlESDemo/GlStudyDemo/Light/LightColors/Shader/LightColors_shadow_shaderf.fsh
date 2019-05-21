
varying lowp vec3 Normal;//片段的法向量
varying lowp vec3 FragPos;//输入变量 片段的世界空间位置

uniform lowp vec3 objectColor;
uniform lowp vec3 lightColor;
uniform lowp vec3 lightPos;//光的位置

void main()
{
    //第一种：光照乘以物体颜色得到眼睛看到的颜色，这里灯光为白色剩以物体颜色，仍然为物体颜色
//    gl_FragColor = vec4(lightColor * objectColor, 1.0);
    
    //第二种：添加环境光照,表现效果为很黑暗
    lowp float ambientStrength = 0.1;
    lowp vec3 ambient = ambientStrength * lightColor;
    
//    lowp vec3 result = ambient * objectColor;//环境光乘以物体颜色
    
    //第三种 漫放射  normalize函数是将变为单位向量，我们不关注向量的长度，只在意方向
    lowp vec3 norm = normalize(Normal);
    //光的方向向量是光源位置向量与片段位置向量之间的向量差
    lowp vec3 lightDir = normalize(lightPos - FragPos);
  /*计算光源对当前片段实际的漫发射影响，片段法向量乘以光的方向，得到角度，两个向量之间的角度越大，漫反射分量就会越小如果两个向量之间的角度大于90度，点乘的结果就会变成负数，这样会导致漫反射分量变为负数。为此，我们使用max函数返回两个参数之间较大的参数,从而保证漫反射分量不会变成负数。*/
    lowp float diff = max(dot(norm, lightDir), 0.0);
    lowp vec3 diffuse = diff * lightColor;
    
    //环境光分量和漫反射分量相加乘以物体颜色得到最终显示颜色
    lowp vec3 result = (ambient + diffuse) * objectColor;
    
    gl_FragColor = vec4(result, 1.0);
}
