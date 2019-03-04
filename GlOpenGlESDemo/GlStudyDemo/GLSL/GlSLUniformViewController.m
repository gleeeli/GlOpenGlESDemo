//
//  GlSLUniformViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "GlSLUniformViewController.h"

@interface GlSLUniformViewController ()
@property (nonatomic, assign) NSTimeInterval startTime;
@end

@implementation GlSLUniformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

/**
 初始化着色器程序字符串
 */
- (void)initShaderString {
    // FIXME:从顶点着色器传值到片段着色器
    vertexShaderSource = "attribute vec3 Position;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(Position.x, Position.y, Position.z, 1.0);\n"
    "}\0";
    
    // 接收传值
    fragmentShaderSource = "uniform lowp vec4 ourColor; // 全局变量;\n"//// 从顶点着色器传来的输入变量（名称相同、类型相同）
    "void main()\n"
    "{\n"
    "   gl_FragColor = ourColor;\n"
    "}\0";
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    // 清除颜色缓冲
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    float timeValue = nowtime - self.startTime;
    float greenValue = (sin(timeValue) / 2.0f) + 0.5f;
    
    int vertexColorLocation = glGetUniformLocation(shaderProgram, "ourColor");
    glUseProgram(shaderProgram);//在当前激活的着色器程序中设置uniform
    glUniform4f(vertexColorLocation, 0.0f, greenValue, 0.0f, 1.0f);
    
    // 绘制三角形
    glBindVertexArrayOES(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}
@end
