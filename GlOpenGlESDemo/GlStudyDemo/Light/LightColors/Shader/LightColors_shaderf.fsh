
//varying lowp vec4 FragColor;
uniform lowp vec3 objectColor;
uniform lowp vec3 lightColor;

void main()
{
    //第一种：光照乘以物体颜色得到眼睛看到的颜色，这里灯光为白色剩以物体颜色，仍然为物体颜色
    gl_FragColor = vec4(lightColor * objectColor, 1.0);
    
    
}
