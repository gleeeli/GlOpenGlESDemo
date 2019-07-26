//
//  TransformViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/3/6.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "TransformViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <iostream>


@interface TransformViewController ()

@end

@implementation TransformViewController
{
    glm::mat4 trans;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)initBaseInfo {
    self.vsFileName = @"transform_shaderv";
    self.fsFileName = @"two_texture_shaderf";
}

- (void)loadTexture {
    [super loadTexture];
    
    //得到旋转和缩放矩阵
    [self rotateAndScale];
    
    unsigned int transformLoc = glGetUniformLocation(shaderProgram, "transform");
    glUniformMatrix4fv(transformLoc, 1, GL_FALSE, glm::value_ptr(trans));
}

/**
 旋转和缩放
 首先我们把箱子逆时针旋转90度。然后缩放0.5倍，使它变成原来的一半大。
 */
- (void)rotateAndScale {
    //初始化为单位矩阵 低版本直接：glm::mat4 trans;
    trans = glm::mat4(1.0f);
    trans = glm::rotate(trans, glm::radians(90.0f), glm::vec3(0.0, 0.0, 1.0));//最后一个参数设置旋转轴为z轴
    trans = glm::scale(trans, glm::vec3(0.5, 0.5, 0.5));
}

/**
 位移
 */
- (void)translate {
    glm::vec4 vec(1.0f, 0.0f, 0.0f, 1.0f);//原始坐标
    //初始化为单位矩阵 低版本直接：glm::mat4 trans;
    glm::mat4 trans = glm::mat4(1.0f);
    trans = glm::translate(trans, glm::vec3(1.0f, 1.0f, 0.0f));//位移值
    vec = trans * vec;
    //NSLog(@"x:%f,y:%f,z:%f",vec.x,vec.y,vec.z);
    std::cout << vec.x << vec.y << vec.z << std::endl;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // bind textures on corresponding texture units
    glActiveTexture(GL_TEXTURE0);// 在绑定纹理之前先激活纹理单元
    glBindTexture(GL_TEXTURE_2D, self.myTexture1);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.myTexture2);
    

    // render container
    [self useProgram];
    
    //移动到右下角后开始不断旋转
    trans = glm::mat4(1.0f);//先设为单位矩阵，不然不对，因为前面已经赋值了
    trans = glm::translate(trans, glm::vec3(0.5f, -0.5f, 0.0f));//x方向 右移一般，y方向下移一半
    trans = glm::rotate(trans, (float)[self getTimeRuning], glm::vec3(0.0f, 0.0f, 1.0f));//绕z转
    //设置全局变量
    unsigned int transformLoc = glGetUniformLocation(shaderProgram, "transform");
    glUniformMatrix4fv(transformLoc, 1, GL_FALSE, glm::value_ptr(trans));
    
    glBindVertexArrayOES(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    
    
    // 左上角增加一个，不断放大缩小
    // ---------------------
    trans = glm::mat4(1.0f); // reset it to identity matrix
    trans = glm::translate(trans, glm::vec3(-0.5f, 0.5f, 0.0f));
    float scaleAmount = sin([self getTimeRuning]);
    trans = glm::scale(trans, glm::vec3(scaleAmount, scaleAmount, scaleAmount));
    glUniformMatrix4fv(transformLoc, 1, GL_FALSE, &trans[0][0]); // this time take the matrix value array's first element as its memory pointer value
    
    // now with the uniform matrix being replaced with new transformations, draw it again.
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}

/*
 公式：v¯⋅k¯ = ||v¯||⋅||k¯||⋅cosθ
 cosθ = v¯⋅k / ||v¯||⋅||k¯||
 
 GLM库从0.9.9版本起，默认会将矩阵类型初始化为一个零矩阵（所有元素均为0），而不是单位矩阵（对角元素为1，其它元素为0）。如果你使用的是0.9.9或0.9.9以上的版本，你需要将所有的矩阵初始化改为 glm::mat4 mat = glm::mat4(1.0f)。如果你想与本教程的代码保持一致，请使用低于0.9.9版本的GLM，或者改用上述代码初始化所有的矩阵。
 */

@end
