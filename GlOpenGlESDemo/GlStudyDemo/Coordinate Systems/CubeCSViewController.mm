//
//  CubeCSViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/4/12.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "CubeCSViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#include <string>

@interface CubeCSViewController ()

@end

@implementation CubeCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)handleVertex {
    NSLog(@"handle vertex");
    
    glEnable(GL_DEPTH_TEST);
    
    //一共需要36个顶点（6个面 x 每个面有2个三角形组成 x 每个三角形有3个顶点）
//    float vertices[] = {
//        // z轴上的两个平行面
        //前平面
//        0.5f,  0.5f, 0.0f,   1.0f, 1.0f, // top right
//        0.5f, -0.5f, 0.0f,   1.0f, 0.0f, // bottom right
//        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f,  0.5f, 0.0f,   0.0f, 1.0f,  // top left
//        0.5f,  0.5f, 0.0f,   1.0f, 1.0f, // top right
//
        //后平面
//        0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//        0.5f, -0.5f, -0.5f,   1.0f, 0.0f, // bottom right
//        -0.5f, -0.5f, -0.5f,   0.0f, 0.0f, // bottom left
//        -0.5f, -0.5f, -0.5f,   0.0f, 0.0f, // bottom left
//        -0.5f,  0.5f, -0.5f,   0.0f, 1.0f,  // top left
//        0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//
//        // x轴上的两个平行面
//        0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//        0.5f, 0.0f, -0.5f,   1.0f, 0.0f, // bottom right
//        0.5f, 0.0f, 0.0f,   0.0f, 0.0f, // bottom left
//        0.5f, 0.0f, 0.0f,   0.0f, 0.0f, // bottom left
//        0.5f,  0.5f, 0.0f,   0.0f, 1.0f,  // top left
//        0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//
//        -0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//        -0.5f, 0.0f, -0.5f,   1.0f, 0.0f, // bottom right
//        -0.5f, 0.0f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f, 0.0f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f,  0.5f, 0.0f,   0.0f, 1.0f,  // top left
//        -0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//
//        // y轴上的两个平行面
//        //上平面
//        0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//        0.5f, 0.5f, 0.0f,   1.0f, 0.0f, // bottom right
//        -0.5f, 0.5f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f, 0.5f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f,  0.5f, -0.5f,   0.0f, 1.0f,  // top left
//        0.5f,  0.5f, -0.5f,   1.0f, 1.0f, // top right
//
//        //下平面
//        0.5f,  -0.5f, -0.5f,   1.0f, 1.0f, // top right
//        0.5f, -0.5f, 0.0f,   1.0f, 0.0f, // bottom right
//        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
//        -0.5f,  -0.5f, -0.5f,   0.0f, 1.0f,  // top left
//        0.5f,  -0.5f, -0.5f,   1.0f, 1.0f // top right
//    };
    
    float vertices[] = {
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,//后下左
        0.5f, -0.5f, -0.5f,  1.0f, 0.0f,//后下右边
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
        
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        
//        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
//        -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
//        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
//        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
//        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
//        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
//
//        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
//        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
//        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
//        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
//        0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
//        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        
//        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
//        0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
//        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
//        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
//        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
//        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
    };
    
    unsigned int VBO,EBO;
    glGenVertexArraysOES(1, &VAO);
    glGenBuffers(1, &VBO);
//    glGenBuffers(1, &EBO);
    
    glBindVertexArrayOES(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // position attribute
    GLuint position = glGetAttribLocation(shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
    
    // texture coord attribute
    GLuint aTexCoord = glGetAttribLocation(shaderProgram, "aTexCoord");
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE,5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(aTexCoord);
    
    glEnable(GL_DEPTH_TEST);
}

- (void)handle3D {
    glEnable(GL_DEPTH_TEST);
    NSTimeInterval interval = [self getTimeRuning];
//    interval = 0;
    glm::mat4 model         = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    //将其绕着x轴旋转，使它看起来像放在地上一样  最后一个参数决定绕x y z轴旋转 这里x：0.5f代表
    model = glm::rotate(model, (float)interval, glm::vec3(0.5f, 1.0f, 0.0f));
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

- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4 {
    glUniformMatrix4fv(glGetUniformLocation(shaderProgram, name.c_str()), 1, GL_FALSE, &mat4[0][0]);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // bind Texture
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.myTexture);
    
    [self useProgram];
    [self handle3D];
    glBindVertexArrayOES(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 18);
}


@end
