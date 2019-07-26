//
//  CoordinateSystemsViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/11.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "CoordinateSystemsViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
//#include <iostream>
#include <string>

@interface CoordinateSystemsViewController ()

@end

@implementation CoordinateSystemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTexture];
}

- (void)initBaseInfo {
    self.vsFileName = @"simple3D_shaderv";
    self.fsFileName = @"simple3D_shaderf";
}

- (void)handleVertex {
    NSLog(@"handle vertex");
    float vertices[] = {
        // positions          // texture coords
        0.5f,  0.5f, 0.0f,   1.0f, 1.0f, // top right
        0.5f, -0.5f, 0.0f,   1.0f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
        -0.5f,  0.5f, 0.0f,   0.0f, 1.0f  // top left
    };
    unsigned int indices[] = {
        0, 1, 3, // first triangle
        1, 2, 3  // second triangle
    };
    unsigned int VBO,EBO;
    glGenVertexArraysOES(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    
    glBindVertexArrayOES(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // position attribute
    GLuint position = glGetAttribLocation(shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);

    // texture coord attribute
    GLuint aTexCoord = glGetAttribLocation(shaderProgram, "aTexCoord");
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE,5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(aTexCoord);
}

- (void)handle3D {
    
    glm::mat4 model         = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    //将其绕着x轴旋转，使它看起来像放在地上一样  最后一个参数决定绕x y z轴旋转
    model = glm::rotate(model, glm::radians(-60.0f), glm::vec3(1.0f, 0.0f, 0.0f));
    // 注意，我们将矩阵向我们要进行移动场景的反方向移动。这里向z轴移动，负数代表远离屏幕的效果
    view  = glm::translate(view, glm::vec3(0.0f, 0.0f, -4.0f));
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(45.0f), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    // retrieve the matrix uniform locations
    unsigned int modelLoc = glGetUniformLocation(shaderProgram, "model");
    unsigned int viewLoc  = glGetUniformLocation(shaderProgram, "view");
    // pass them to the shaders (3 different ways)
    glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(model));
    glUniformMatrix4fv(viewLoc, 1, GL_FALSE, &view[0][0]);
    [self setMat4:"projection" mat4:projection];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // bind Texture
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.myTexture);
    
    [self useProgram];
    [self handle3D];
    glBindVertexArrayOES(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}

- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4 {
    glUniformMatrix4fv(glGetUniformLocation(shaderProgram, name.c_str()), 1, GL_FALSE, &mat4[0][0]);
}

/*
 整射投影：正射平截头体直接将平截头体内部的所有坐标映射为标准化设备坐标，因为每个向量的w分量都没有进行改变；如果w分量等于1.0，透视除法则不会改变这个坐标。特征：远处物体看起来不会变小
 要创建一个正射投影矩阵，我们可以使用GLM的内置函数glm::ortho：
 
 glm::ortho(0.0f, 800.0f, 0.0f, 600.0f, 0.1f, 100.0f);
 
 
 在GLM中可以这样创建一个透视投影矩阵：
 
 glm::mat4 proj = glm::perspective(glm::radians(45.0f), (float)width/(float)height, 0.1f, 100.0f);
 
 它的第一个参数定义了fov的值，它表示的是视野(Field of View)，并且设置了观察空间的大小。如果想要一个真实的观察效果，它的值通常设置为45.0f，但想要一个末日风格的结果你可以将其设置一个更大的值。第二个参数设置了宽高比，由视口的宽除以高所得。第三和第四个参数设置了平截头体的近和远平面。我们通常设置近距离为0.1f，而远距离设为100.0f。所有在近平面和远平面内且处于平截头体内的顶点都会被渲染。
*/

@end
