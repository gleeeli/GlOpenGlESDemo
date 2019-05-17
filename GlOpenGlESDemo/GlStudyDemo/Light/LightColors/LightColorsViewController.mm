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
    lightShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_shaderf"];
    lamShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_light source_shaderf"];
    //手势 摄像头控制，此处设置摄像头的位置,注意不是物体坐标
    camera = [[CommCamera alloc] initWithBackView:self.view cameraPos:glm::vec3(0.0f, 0.8f, 4.0f)];
    [self handleVertex];
}

- (void)getVertices:(float *)vertices {
    //一共需要36个顶点（6个面 x 每个面有2个三角形组成 x 每个三角形有3个顶点）
    *vertices[] = {
        // z轴上的两个平行面
        //前平面
        0.5f,  0.5f, 0.0f,    // top right
        0.5f, -0.5f, 0.0f,   // bottom right
        -0.5f, -0.5f, 0.0f,   // bottom left
        -0.5f, -0.5f, 0.0f,   // bottom left
        -0.5f,  0.5f, 0.0f,    // top left
        0.5f,  0.5f, 0.0f,    // top right
        
        //后平面
        0.5f,  0.5f, -0.5f,    // top right
        0.5f, -0.5f, -0.5f,    // bottom right
        -0.5f, -0.5f, -0.5f,  // bottom left
        -0.5f, -0.5f, -0.5f,   // bottom left
        -0.5f,  0.5f, -0.5f,    // top left
        0.5f,  0.5f, -0.5f,   // top right
        
        // x轴上的两个平行面
        //右平面
        0.5f,  0.5f, -0.5f,   // top right
        0.5f, -0.5f, -0.5f,   // bottom right
        0.5f, -0.5f, 0.0f,  // bottom left
        0.5f, -0.5f, 0.0f,   // bottom left
        0.5f,  0.5f, 0.0f,   // top left
        0.5f,  0.5f, -0.5f,  // top right
        
        //左平面 留个缺口，不留缺口可将y轴的0.0f改为-0.5f
        -0.5f,  0.5f, -0.5f,  // top right
        -0.5f, 0.0f, -0.5f,   // bottom right
        -0.5f, 0.0f, 0.0f,  // bottom left
        -0.5f, 0.0f, 0.0f,  // bottom left
        -0.5f,  0.5f, 0.0f,   // top left
        -0.5f,  0.5f, -0.5f,   // top right
        
        // y轴上的两个平行面
        //上平面
        0.5f,  0.5f, -0.5f,  // top right
        0.5f, 0.5f, 0.0f,  // bottom right
        -0.5f, 0.5f, 0.0f,  // bottom left
        -0.5f, 0.5f, 0.0f,  // bottom left
        -0.5f,  0.5f, -0.5f,   // top left
        0.5f,  0.5f, -0.5f,  // top right
        
        //下平面
        0.5f,  -0.5f, -0.5f,  // top right
        0.5f, -0.5f, 0.0f,    // bottom right
        -0.5f, -0.5f, 0.0f,   // bottom left
        -0.5f, -0.5f, 0.0f,   // bottom left
        -0.5f,  -0.5f, -0.5f,   // top left
        0.5f,  -0.5f, -0.5f, // top right
    };

}

- (void)handleVertex {
    NSLog(@"handle vertex");
    //18 * 6 = 108;
    float *vertices = malloc(108 * sizeof(float*));
    
//    //一共需要36个顶点（6个面 x 每个面有2个三角形组成 x 每个三角形有3个顶点）
//    float vertices[] = {
//        // z轴上的两个平行面
//        //前平面
//        0.5f,  0.5f, 0.0f,    // top right
//        0.5f, -0.5f, 0.0f,   // bottom right
//        -0.5f, -0.5f, 0.0f,   // bottom left
//        -0.5f, -0.5f, 0.0f,   // bottom left
//        -0.5f,  0.5f, 0.0f,    // top left
//        0.5f,  0.5f, 0.0f,    // top right
//
//        //后平面
//        0.5f,  0.5f, -0.5f,    // top right
//        0.5f, -0.5f, -0.5f,    // bottom right
//        -0.5f, -0.5f, -0.5f,  // bottom left
//        -0.5f, -0.5f, -0.5f,   // bottom left
//        -0.5f,  0.5f, -0.5f,    // top left
//        0.5f,  0.5f, -0.5f,   // top right
//
//        // x轴上的两个平行面
//        //右平面
//        0.5f,  0.5f, -0.5f,   // top right
//        0.5f, -0.5f, -0.5f,   // bottom right
//        0.5f, -0.5f, 0.0f,  // bottom left
//        0.5f, -0.5f, 0.0f,   // bottom left
//        0.5f,  0.5f, 0.0f,   // top left
//        0.5f,  0.5f, -0.5f,  // top right
//
//        //左平面 留个缺口，不留缺口可将y轴的0.0f改为-0.5f
//        -0.5f,  0.5f, -0.5f,  // top right
//        -0.5f, 0.0f, -0.5f,   // bottom right
//        -0.5f, 0.0f, 0.0f,  // bottom left
//        -0.5f, 0.0f, 0.0f,  // bottom left
//        -0.5f,  0.5f, 0.0f,   // top left
//        -0.5f,  0.5f, -0.5f,   // top right
//
//        // y轴上的两个平行面
//        //上平面
//        0.5f,  0.5f, -0.5f,  // top right
//        0.5f, 0.5f, 0.0f,  // bottom right
//        -0.5f, 0.5f, 0.0f,  // bottom left
//        -0.5f, 0.5f, 0.0f,  // bottom left
//        -0.5f,  0.5f, -0.5f,   // top left
//        0.5f,  0.5f, -0.5f,  // top right
//
//        //下平面
//        0.5f,  -0.5f, -0.5f,  // top right
//        0.5f, -0.5f, 0.0f,    // bottom right
//        -0.5f, -0.5f, 0.0f,   // bottom left
//        -0.5f, -0.5f, 0.0f,   // bottom left
//        -0.5f,  -0.5f, -0.5f,   // top left
//        0.5f,  -0.5f, -0.5f, // top right
//    };
    glGenVertexArraysOES(1, &cubeVAO);
    glGenBuffers(1, &VBO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(cubeVAO);
    
    // position attribute
    GLuint position = glGetAttribLocation(lightShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
    
    [self createlampVAO];
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
}

- (void)handleCube3D {
    [lightShader useProgram];
    [lightShader setVec3:"objectColor" x:1.0f y:0.5f z:0.31f];
    [lightShader setVec3:"lightColor" x:1.0f y:1.0f z:1.0f];
    
    glm::mat4 model         = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    
    view  = [camera GetViewMatrix];
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(camera.zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    
    [lightShader setMat4:"projection" mat4:projection];
    [lightShader setMat4:"view" mat4:view];
    
//    model = glm::rotate(model, 1.f, glm::vec3(0.5f, 1.0f, 0.0f));
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
    
    // lighting
    glm::vec3 lightPos(0.2f, 1.0f, 2.0f);
    glm::mat4 model         = glm::mat4(1.0f);
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
