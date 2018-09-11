//
//  DrawTrangleViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2018/9/11.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "DrawTrangleViewController.h"

@interface DrawTrangleViewController ()

@end

//const char *vertexShaderSource = "#version 100 core\n"
//"layout (location = 0) in vec3 aPos;\n"
//"void main()\n"
//"{\n"
//"   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
//"}\0";

//const char *fragmentShaderSource = "#version 100 core\n"
//"out vec4 FragColor;\n"
//"void main()\n"
//"{\n"
//"   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
//"}\n\0";

const char *vertexShaderSource = "uniform mat4 projTrans;\n"
"layout (location = 0) in vec3 aPos;\n"
"void main() {\n"
    "gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
"}\0";

const char *fragmentShaderSource = "uniform sampler2D tex0;\n"
"varying vec2 vTexCoord;\n"
"void main() {"
"vec4 color = texture2D(tex0, vTexCoord);\n"
"gl_FragColor = color;\n"
"}\n\0";

@implementation DrawTrangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    unsigned char *str = glGetString(GL_VERSION);
    printf("version %s",str);
    [self drawTangle];
}

- (void)drawTangle{
    float vertices[] = {
        // first triangle
        -0.9f, -0.5f, 0.0f,  // left
        -0.0f, -0.5f, 0.0f,  // right
        -0.45f, 0.5f, 0.0f,  // top
        // second triangle
        0.0f, -0.5f, 0.0f,  // left
        0.9f, -0.5f, 0.0f,  // right
        0.45f, 0.5f, 0.0f   // top
    };
    
    GLuint VBO, VAO;
//    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //创建一个着色器对象 类型为顶点着色器GL_VERTEX_SHADER
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    //着色器源码附加到着色器对象上 第二参数指定了传递的源码字符串数量 第三个参数是顶点着色器真正的源码
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    //打印错误
    int  success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        printf("%s",infoLog);
    }
    
    //片段着色器(Fragment Shader)是第二个也是最后一个我们打算创建的用于渲染三角形的着色器
    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    //着色器程序对象(Shader Program Object)是多个着色器合并之后并最终链接完成的版本
    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if(!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        printf("%s",infoLog);
    }
    
    
    //删除着色器对象
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    /*上面的代码，已经把输入顶点数据发送给了GPU，并指示了GPU如何在顶点和片段着色器中处理它，但OpenGL还不知道它该如何解释内存中的顶点数据，以及它该如何将顶点数据链接到顶点着色器的属性上*/
    
    /*第一个参数指定我们要配置的顶点属性。还记得我们在顶点着色器中使用layout(location = 0)定义了position顶点属性的位置值(Location)吗？它可以把顶点属性的位置值设置为0。因为我们希望把数据传递到这一个顶点属性中，所以这里我们传入0。
     第二个参数指定顶点属性的大小。顶点属性是一个vec3，它由3个值组成，所以大小是3。
     第三个参数指定数据的类型，这里是GL_FLOAT(GLSL中vec*都是由浮点数值组成的)。
     下个参数定义我们是否希望数据被标准化(Normalize)。如果我们设置为GL_TRUE，所有数据都会被映射到0（对于有符号型signed数据是-1）到1之间。我们把它设置为GL_FALSE。
     第五个参数叫做步长(Stride)，它告诉我们在连续的顶点属性组之间的间隔。由于下个组位置数据在3个float之后，我们把步长设置为3 * sizeof(float)。要注意的是由于我们知道这个数组是紧密排列的（在两个顶点属性之间没有空隙）我们也可以设置为0来让OpenGL决定具体步长是多少（只有当数值是紧密排列时才可用）。一旦我们有更多的顶点属性，我们就必须更小心地定义每个顶点属性之间的间隔，我们在后面会看到更多的例子（译注: 这个参数的意思简单说就是从这个属性第二次出现的地方到整个数组0位置之间有多少字节）。
     最后一个参数的类型是void*，所以需要我们进行这个奇怪的强制类型转换。它表示位置数据在缓冲中起始位置的偏移量(Offset)。由于位置数据在数组的开头，所以这里是0。我们会在后面详细解释这个参数。*/
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    //以顶点属性位置值作为参数，启用顶点属性；顶点属性默认是禁用的
    glEnableVertexAttribArray(0);
    
    // 3. 绘制物体
    //激活这个程序对象：
    glUseProgram(shaderProgram);
//    glBindVertexArray(VAO);
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    //[self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
