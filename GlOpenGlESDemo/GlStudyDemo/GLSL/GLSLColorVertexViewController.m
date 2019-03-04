//
//  GLSLColorVertexViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "GLSLColorVertexViewController.h"

@interface GLSLColorVertexViewController ()

@end

@implementation GLSLColorVertexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 开始处理顶点数据
 */
- (void)handleVertex {
    float vertices[] = {
        // 位置              // 颜色
        0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,   // 右下
        -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,   // 左下
        0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f    // 顶部
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
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    
    
    GLuint aColor = glGetAttribLocation(shaderProgram, "aColor");
    // 颜色属性 颜色属性紧随位置数据之后，所以偏移量就是3 * sizeof(float)，用字节来计算就是12字节
    glVertexAttribPointer(aColor, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3* sizeof(float)));
    glEnableVertexAttribArray(aColor);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
}

/**
 初始化着色器程序字符串
 */
- (void)initShaderString {
    // FIXME:从顶点着色器传值到片段着色器
    vertexShaderSource = "attribute vec3 Position;\n"
    "attribute vec3 aColor;\n"//输入颜色
    "varying lowp vec3 ourColor;\n"//输出
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(Position.x, Position.y, Position.z, 1.0);\n"
    "   ourColor = aColor; // 把输出变量设置为暗红色;\n"
    "}\0";
    
    // 接收传值
    fragmentShaderSource = "varying lowp vec3 ourColor;\n"// 从顶点着色器传来的输入变量（名称相同、类型相同）
    "void main()\n"
    "{\n"
    "   gl_FragColor = vec4(ourColor, 1.0);\n"
    "}\0";
}

/*
 光栅会根据每个片段在三角形形状上所处相对位置决定这些片段的位置。
 基于这些位置，它会插值(Interpolate)所有片段着色器的输入变量。比如说，我们有一个线段，上面的端点是绿色的，下面的端点是蓝色的。如果一个片段着色器在线段的70%的位置运行，它的颜色输入属性就会是一个绿色和蓝色的线性结合；更精确地说就是30%蓝 + 70%绿。
 */
@end
