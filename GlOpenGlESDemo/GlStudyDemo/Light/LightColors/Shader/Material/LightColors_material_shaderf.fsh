struct Material {
    lowp vec3 ambient;//环境光照
    lowp vec3 diffuse;//漫反射光照下物体的颜色
    lowp vec3 specular;//镜面光照对物体的颜色影响（或者甚至可能反射一个物体特定的镜面高光颜色 值越大被直照的光圈会越亮
    lowp float shininess;//影响镜面高光的散射/半径。
};

struct Light {
    lowp vec3 position;
    
    lowp vec3 ambient;
    lowp vec3 diffuse;
    lowp vec3 specular;
};

varying lowp vec3 Normal;//片段的法向量
varying lowp vec3 FragPos;//输入变量 片段的世界空间位置

//uniform lowp vec3 objectColor;
//uniform lowp vec3 lightColor;
//uniform lowp vec3 lightPos;//光的位置
uniform lowp vec3 viewPos;//摄像机位置坐标 镜面光照需要
uniform Material material;//材质
uniform Light light;


void main()
{
    //第一种：光照乘以物体颜色得到眼睛看到的颜色，这里灯光为白色剩以物体颜色，仍然为物体颜色
//    gl_FragColor = vec4(lightColor * objectColor, 1.0);
    
    //第二种：添加环境光照
    lowp vec3 ambient = light.ambient * material.ambient;
    
//    lowp vec3 result = ambient * objectColor;//环境光乘以物体颜色
    
    //第三种 漫放射  normalize函数是将变为单位向量，我们不关注向量的长度，只在意方向
    lowp vec3 norm = normalize(Normal);
    //光的方向向量是光源位置向量与片段位置向量之间的向量差
    lowp vec3 lightDir = normalize(light.position - FragPos);
  /*计算光源对当前片段实际的漫发射影响，片段法向量乘以光的方向，得到角度，两个向量之间的角度越大，漫反射分量就会越小如果两个向量之间的角度大于90度，点乘的结果就会变成负数，这样会导致漫反射分量变为负数。为此，我们使用max函数返回两个参数之间较大的参数,从而保证漫反射分量不会变成负数。*/
    highp float diff = max(dot(norm, lightDir), 0.0);
    lowp vec3 diffuse = light.diffuse * (diff * material.diffuse);

    //环境光分量和漫反射分量相加乘以物体颜色得到最终显示颜色
//    lowp vec3 result = (ambient + diffuse) * objectColor;

    //第四种镜面光照 与摄像头角度和光照角度有关，理解为反光
    lowp vec3 viewDir = normalize(viewPos - FragPos);
    //需要注意的是我们对lightDir向量进行了取反。reflect函数要求第一个向量是从光源指向片段位置的向量
    lowp vec3 reflectDir = reflect(-lightDir, norm);

    //这个32是高光的反光度(Shininess)。一个物体的反光度越高，反射光的能力越强，散射得越少，高光点就会越小
    highp float dotr = dot(viewDir, reflectDir);
    highp float spec = pow(max(dotr, 0.0), material.shininess);
    lowp vec3 specular = light.specular * (spec * material.specular);
//    lowp vec3 result = (ambient + diffuse + specular) * objectColor;
    
    lowp vec3 result = ambient + diffuse + specular;
    
    gl_FragColor = vec4(result, 1.0);
}
