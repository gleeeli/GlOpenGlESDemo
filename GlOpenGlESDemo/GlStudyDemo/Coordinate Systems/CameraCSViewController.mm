//
//  CameraCSViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/19.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "CameraCSViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#include <string>
#include <OpenGLES/ES2/glext.h>

@interface CameraCSViewController ()

@end

@implementation CameraCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)handle3D {
    NSTimeInterval interval = [self getTimeRuning];
    //    interval = 1;
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    
    //此处LookAt函数需要一个位置、目标和上向量。它会创建一个观察矩阵。将世界坐标变换到以摄像机为原点的坐标系统
    //在这里不断改变摄像机的位置，此处摄像机y不变，让摄像机位置绕着圆形轨迹移动。（知道夹角，和半径，利用sin和cos可求出x和z的坐标）
    float radius = 10.0f;
    float camX = sin(interval) * radius;
    float camZ = cos(interval) * radius;
    view = glm::lookAt(glm::vec3(camX, 0.0, camZ), glm::vec3(0.0, 0.0, 0.0), glm::vec3(0.0, 1.0, 0.0));
    
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(45.0f), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    
    //绑定到shader GLSL
    unsigned int viewLoc  = glGetUniformLocation(shaderProgram, "view");
    // pass them to the shaders (3 different ways)
    glUniformMatrix4fv(viewLoc, 1, GL_FALSE, &view[0][0]);
    [self setMat4:"projection" mat4:projection];
}

- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4 {
    glUniformMatrix4fv(glGetUniformLocation(shaderProgram, name.c_str()), 1, GL_FALSE, &mat4[0][0]);
}

/*
 使用矩阵的好处之一是如果你使用3个相互垂直（或非线性）的轴定义了一个坐标空间，你可以用这3个轴外加一个平移向量来创建一个矩阵，并且你可以用这个矩阵乘以任何向量来将其变换到那个坐标空间。这正是LookAt矩阵所做的.
 创建LookAt矩阵：
 glm::LookAt函数需要一个位置、目标（保证照相机对着某个方向，从当前位置向目标位置看去，这么理解）和上向量。它会创建一个和在上一节使用的一样的观察矩阵。
 glm::mat4 view;
 view = glm::lookAt(glm::vec3(0.0f, 0.0f, 3.0f),glm::vec3(0.0f, 0.0f, 0.0f),glm::vec3(0.0f, 1.0f, 0.0f));
*/

@end
