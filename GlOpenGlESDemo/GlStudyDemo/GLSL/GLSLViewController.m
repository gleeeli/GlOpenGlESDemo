//
//  GLSLViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "GLSLViewController.h"

@interface GLSLViewController ()
@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;
@end

@implementation GLSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupOpenGlBase];
    [self initBaseShader];
    [self handleVertex];
    
}


/**
 开始处理顶点数据
 */
- (void)handleVertex {
    float vertices[] = {
        -0.5f, -0.5f, 0.0f, // left
        0.5f, -0.5f, 0.0f, // right
        0.0f,  0.5f, 0.0f  // top
    };
    
    unsigned int VBO;//
    glGenVertexArraysOES(1, &VAO);//顶点数组对象
    //一个缓冲ID生成一个VBO对象
    glGenBuffers(1, &VBO);
    
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArrayOES(VAO);
    
    //顶点缓冲对象的缓冲类型是GL_ARRAY_BUFFER
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    /**
     * GL_STATIC_DRAW ：数据不会或几乎不会改变。
     * GL_DYNAMIC_DRAW：数据会被改变很多。
     * GL_STREAM_DRAW ：数据每次绘制时都会改变。
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    GLuint position = glGetAttribLocation(shaderProgram, "Position");
    //启用顶点属性
    glEnableVertexAttribArray(position);//这里可以用GLKVertexAttribPosition
    //我们必须在渲染前指定OpenGL该如何解释顶点数据。第二个参数：顶点属性是一个vec3，它由3个值组成，所以大小是3。
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
}

- (void)setupOpenGlBase {
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //2.0，还有1.0和3.0
    
    if (!self.mContext) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
}

/**
 初始化着色器程序字符串
 */
- (void)initShaderString {
    // FIXME:从顶点着色器传值到片段着色器
    vertexShaderSource = "attribute vec3 Position;\n"
    "varying lowp vec4 vertexColor;\n"//为片段着色器指定一个颜色输出
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(Position.x, Position.y, Position.z, 1.0);\n"
    "   vertexColor = vec4(0.5, 0.0, 0.0, 1.0); // 把输出变量设置为暗红色;\n"
    "}\0";
    
    // 接收传值
    fragmentShaderSource = "varying lowp vec4 vertexColor;\n"//// 从顶点着色器传来的输入变量（名称相同、类型相同）
    "void main()\n"
    "{\n"
    "   gl_FragColor = vertexColor;\n"
    "}\0";
}

/**
 编译着色器
 */
- (void)initBaseShader {
    [self initShaderString];
    
    int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        NSLog(@"Failed to shader vertexShaderSource:%s",infoLog);
    }
    
    int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    // check for shader compile errors
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        NSLog(@"Failed to shader fragmentShaderSource:%s",infoLog);
    }
    
    // link shaders 着色器程序
    shaderProgram = glCreateProgram();//int
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    // check for linking errors
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        NSLog(@"Failed to link shaderProgram");
    }
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // draw our first triangle
    glUseProgram(shaderProgram);
    glBindVertexArrayOES(VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
    //GL_TRIANGLES：每三个顶之间绘制三角形，之间不连接 参数2：从数组缓存中的哪一位开始绘制，一般都定义为0 参数3：顶点的数量
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

/*
 attribute：表示只读的顶点数据，只用在顶点着色器中。数据来自当前的顶点状态或者顶点数组。它必须是全局范围声明的，不能再函数内部。一个attribute可以是浮点数类型的标量，向量，或者矩阵。不可以是数组或则结构体
 varying：顶点着色器的输出。例如颜色或者纹理坐标，（插值后的数据）作为片段着色器的只读输入数据。必须是全局范围声明的全局变量。可以是浮点数类型的标量，向量，矩阵。不能是数组或者结构体。
 lowp：精度修饰符
 Uniform是一种从CPU中的应用向GPU中的着色器发送数据的方式
 uniform是全局的(Global) 命名必须唯一，可以任意阶段使用,除非被重置，不然一直保存数据
 */
@end
