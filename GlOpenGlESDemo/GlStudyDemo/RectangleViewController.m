//
//  RectangleViewController.m
//  LearnOpenGLES
//
//  Created by 小柠檬 on 2019/3/1.
//  Copyright © 2019年 林伟池. All rights reserved.
//

#import "RectangleViewController.h"
#import <OpenGLES/ES2/glext.h>

@interface RectangleViewController ()
@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;
@end

@implementation RectangleViewController
{
    int shaderProgram;
    unsigned int VAO;
    unsigned int EBO;
    unsigned int VBO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupOpenGlBase];
    [self initBaseShader];
    
    float vertices[] = {
        0.5f, 0.5f, 0.0f,   // 右上角
        0.5f, -0.5f, 0.0f,  // 右下角
        -0.5f, -0.5f, 0.0f, // 左下角
        -0.5f, 0.5f, 0.0f   // 左上角
    };
    
    unsigned int indices[] = { // 注意索引从0开始!
        0, 1, 3, // 第一个三角形
        1, 2, 3  // 第二个三角形
    };
    
//    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    
    glGenVertexArraysOES(1, &VAO);//顶点数组对象
    glGenBuffers(1, &VBO);//顶点缓冲对象
    glGenBuffers(1, &EBO);//索引缓冲对象 确定顶点绘制顺序 减少绘制步骤
    
    // 1. 绑定顶点数组对象
    glBindVertexArrayOES(VAO);
    
    // 2. 把我们的顶点数组复制到一个顶点缓冲中，供OpenGL使用
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //绑定索引
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    //将索引放入缓冲
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // 4. 设定顶点属性指针 从指针0开始每隔3个位置为一个顶点的起点
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
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

- (void)initBaseShader {
    //将顶点坐标赋值给gl_Position
    const char *vertexShaderSource = "attribute vec3 Position;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(Position.x, Position.y, Position.z, 1.0);\n"
    "}\0";
    
    //固定颜色值
    const char *fragmentShaderSource = "void main()\n"
    "{\n"
    "   gl_FragColor = vec4(1.0, 0.5, 0.2, 1.0);\n"
    "}\0";
    
    int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        NSLog(@"Failed to shader vertexShaderSource");
    }
    
    int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    // check for shader compile errors
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        NSLog(@"Failed to shader fragmentShaderSource");
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
    
    glUseProgram(shaderProgram);
    glBindVertexArrayOES(VAO);
    /*
     第二个参数是我们打算绘制顶点的个数，这里填6，也就是说我们一共需要绘制6个顶点(两个三角形6个顶点)
     第三个参数是索引的类型，这里是GL_UNSIGNED_INT
     最后一个参数里我们可以指定EBO中的偏移量（或者传递一个索引数组，但是这是当你不在使用索引缓冲对象的时候），但是我们会在这里填写0。
     */
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    glBindVertexArrayOES(0);
}

@end
