//
//  LightColorsViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/16.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "LightColorsViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#include <string>
#include <OpenGLES/ES2/glext.h>
#import "CommCamera.h"
#import "CommShader.h"
#include <OpenGLES/ES2/glext.h>
#import "CommVertices.h"
#import "CommVertices.h"

// lighting 灯的位置
glm::vec3 lightPos(0.3f, 1.2f, 2.0f);

@implementation LightColorsViewController
{
    unsigned int VBO;
    unsigned int cubeVAO;
    unsigned int lampVAO;
    CommCamera *camera;
    CommShader *lightShader;
    CommShader *lamShader;
}


-(void)viewDidLoad {
    [super viewDidLoad];

    [self setupOpenGlBase];
    //编译着色器
    /* 最纯净的光源世界 解开注释需要看对应输入输出变量，以及顶点数组不需要法向量，解析时的开始位置
    lightShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_shaderf"];
    lamShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_light_source_shaderf"];
     */
    
    //带环境光，漫反射的光源世界
    lightShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shadow_shaderv" fsFileName:@"LightColors_shadow_shaderf"];
    lamShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_light_source_shaderf"];
    
    
    //手势 摄像头控制，此处设置摄像头的位置,注意不是物体坐标
    camera = [[CommCamera alloc] initWithBackView:self.view cameraPos:glm::vec3(0.0f, 0.8f, 4.0f)];
    [self handleVertex];
}

- (void)handleVertex {
    NSLog(@"handle vertex");
    //36 * 3 = 108;
    //getCubeAndNoramlVertices 长度为 108 * 2 = 216
    float vertices[216];
    float *tmp = getCubeAndNoramlVertices();
    for (int i = 0; i < 216; i++) {
        vertices[i] = tmp[i];
    }
    
    glGenVertexArraysOES(1, &cubeVAO);
    glGenBuffers(1, &VBO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //绑定立方体顶点
    [self createCubeVAO];
    
    // 绑定灯的顶点
    [self createlampVAO];
}

- (void)createCubeVAO {
    glBindVertexArrayOES(cubeVAO);
    
    // cube position attribute
    GLuint position = glGetAttribLocation(lightShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
    
    //法向量，垂直于每个面
    GLuint normal = glGetAttribLocation(lightShader.shaderProgram, "aNormal");
    glVertexAttribPointer(normal, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(normal);
}

/**
 创建灯的顶点数组对象，要是共用VAO 属性指针做出修改容易影响到灯
 */
- (void)createlampVAO {
    
    glGenVertexArraysOES(1, &lampVAO);
    glBindVertexArrayOES(lampVAO);
    // 只需要绑定VBO不用再次设置VBO的数据，因为箱子的VBO数据中已经包含了正确的立方体顶点数据
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    // 设置灯立方体的顶点属性（对我们的灯来说仅仅只有位置数据）
    GLuint position = glGetAttribLocation(lamShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
}

- (void)handleCube3D {
    [lightShader useProgram];
    //物体颜色
    [lightShader setVec3:"objectColor" x:1.0f y:0.5f z:0.31f];
    //灯颜色
    [lightShader setVec3:"lightColor" x:1.0f y:1.0f z:1.0f];
    
    //设置灯位置 用来求漫反射的
    [lightShader setVec3:"lightPos" vec3:lightPos];
    
    glm::mat4 model         = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    
    //转成摄像机坐标
    view  = [camera GetViewMatrix];
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(camera.zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    
    [lightShader setMat4:"projection" mat4:projection];
    [lightShader setMat4:"view" mat4:view];
    
    //旋转一下 不然太正了
    model = glm::rotate(model, 1.f, glm::vec3(0.5f, 1.0f, 0.0f));
    [lightShader setMat4:"model" mat4:model];
    
    glBindVertexArrayOES(cubeVAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    //绘制灯立方体对象
    [self handleLame3DWithView:view projection:projection];
}

- (void)handleLame3DWithView:(glm::mat4)view projection:(glm::mat4)projection {
    [lamShader useProgram];
    [lamShader setMat4:"projection" mat4:projection];
    [lamShader setMat4:"view" mat4:view];
    
    glm::mat4 model         = glm::mat4(1.0f);
    //移动到指定位置
    model = glm::translate(model, lightPos);
    model = glm::scale(model, glm::vec3(0.2f)); // a smaller cube
    [lamShader setMat4:"model" mat4:model];
    
    glBindVertexArrayOES(lampVAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //手势需要获取绘制每一帧的时长 减少不同设备的差异
    [camera handleDelay];
    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    //深度测试清除缓存
    glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);
    
    [self handleCube3D];
}

- (void)dealloc {
    glDeleteVertexArraysOES(1, &cubeVAO);
    glDeleteVertexArraysOES(1, &lampVAO);
    glDeleteBuffers(1, &VBO);
}
@end
