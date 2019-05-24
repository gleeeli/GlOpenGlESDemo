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

#include <OpenGLES/ES2/glext.h>
#import "CommVertices.h"
#import "CommShader.h"

// lighting 灯的位置
//glm::vec3 lightPos(0.0f, 1.3f, 0.0f);

@implementation LightColorsViewController
{
//    unsigned int VBO;
//    unsigned int cubeVAO;
//    unsigned int lampVAO;
    CommCamera *camera;
//    CommShader *lightShader;
//    CommShader *lamShader;
    glm::vec3 lightPos;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    
    lightPos = glm::vec3(0.0f, 1.3f, 0.0f);

    [self setupOpenGlBase];
    //编译着色器
    /* 最纯净的光源世界 解开注释需要看对应输入输出变量，以及顶点数组不需要法向量，解析时的开始位置
    lightShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_shaderf"];
    lamShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_light_source_shaderf"];
     */
    
    [self initShaderName];
    
    //带环境光，漫反射的光源世界
    self.lightShader = [[CommShader alloc] initWithvsFileName:self.lightVertexShaderName fsFileName:self.lightFrageShaderName];
    self.lamShader = [[CommShader alloc] initWithvsFileName:@"LightColors_shaderv" fsFileName:@"LightColors_light_source_shaderf"];
    
    
    //手势 摄像头控制，此处设置摄像头的位置,注意不是物体坐标
    camera = [[CommCamera alloc] initWithBackView:self.view cameraPos:glm::vec3(0.0f, 0.8f, 3.0f)];
    [self handleVertex];
}

- (void)initShaderName {
    self.lightFrageShaderName = @"LightColors_shadow_shaderf";
    self.lightVertexShaderName = @"LightColors_shadow_shaderv";
}

/**
 设置光源位置
 */
- (void)setLightPost:(float)x y:(float)y z:(float)z {
    lightPos.x = x;
    lightPos.y = y;
    lightPos.z = z;
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
    
    [self handleVBOVAO];
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //绑定立方体顶点
    [self createCubeVAO];
    
    // 绑定灯的顶点
    [self createlampVAO];
}

//VBO 不知道怎么提到外部初始化 暂时这样
- (void)handleVBOVAO {
    glGenVertexArraysOES(1, &_cubeVAO);
    glGenBuffers(1, &_VBO);
    
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
}

- (void)createCubeVAO {
    glBindVertexArrayOES(_cubeVAO);
    
    // cube position attribute
    GLuint position = glGetAttribLocation(self.lightShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
    
    //法向量，垂直于每个面
    GLuint normal = glGetAttribLocation(self.lightShader.shaderProgram, "aNormal");
    glVertexAttribPointer(normal, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(normal);
}

/**
 创建灯的顶点数组对象，要是共用VAO 属性指针做出修改容易影响到灯
 */
- (void)createlampVAO {
    
    glGenVertexArraysOES(1, &_lampVAO);
    glBindVertexArrayOES(_lampVAO);
    // 只需要绑定VBO不用再次设置VBO的数据，因为箱子的VBO数据中已经包含了正确的立方体顶点数据
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    // 设置灯立方体的顶点属性（对我们的灯来说仅仅只有位置数据）
    GLuint position = glGetAttribLocation(self.lamShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
}

/**
 移动灯
 */
-(void)moveLambPosition {
    NSTimeInterval runTime = [self getRunTime];
    float radius = 1.3f;
    lightPos.x = radius * cos(runTime);
    lightPos.y = sin(runTime) * radius;
}

- (NSTimeInterval)getRunTime {
    return [camera getTimeRuning];
}

- (NSArray *)getLightPos {
    return @[[NSNumber numberWithFloat:lightPos.x],[NSNumber numberWithFloat:lightPos.y],[NSNumber numberWithFloat:lightPos.z]];
}

- (void)handleCube3D {
    [self.lightShader useProgram];
    
    [self.lightShader setVec3:"viewPos" vec3:[camera getCameraPosition]];
    [self setOtherLightShader];
    
    glm::mat4 model         = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    
    //转成摄像机坐标
    view  = [camera GetViewMatrix];
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(camera.zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    
    [self.lightShader setMat4:"projection" mat4:projection];
    [self.lightShader setMat4:"view" mat4:view];
    
    //旋转一下 不然太正了
    model = glm::rotate(model, 0.7f, glm::vec3(1.0f, 0.0f, 0.0f));
    [self.lightShader setMat4:"model" mat4:model];
    
    glBindVertexArrayOES(_cubeVAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    //绘制灯立方体对象
    [self handleLame3DWithView:view projection:projection];
}

- (void)setOtherLightShader {
    //物体颜色
    [self.lightShader setVec3:"objectColor" x:1.0f y:0.5f z:0.31f];
    //灯颜色
    [self.lightShader setVec3:"lightColor" x:1.0f y:1.0f z:1.0f];
    
    //设置灯位置 用来求漫反射的
    [self.lightShader setVec3:"lightPos" vec3:lightPos];
}

- (void)handleLame3DWithView:(glm::mat4)view projection:(glm::mat4)projection {
    [self.lamShader useProgram];
    [self.lamShader setMat4:"projection" mat4:projection];
    [self.lamShader setMat4:"view" mat4:view];
    
    glm::mat4 model         = glm::mat4(1.0f);
    //移动到指定位置
    model = glm::translate(model, lightPos);
    model = glm::scale(model, glm::vec3(0.2f)); // a smaller cube
    [self.lamShader setMat4:"model" mat4:model];
    
    glBindVertexArrayOES(_lampVAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //手势需要获取绘制每一帧的时长 减少不同设备的差异
    [camera handleDelay];
    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    //深度测试清除缓存
    glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);
    [self drawHandleOther];
    [self moveLambPosition];
    [self handleCube3D];
}

- (void)drawHandleOther {
    
}

- (void)dealloc {
    glDeleteVertexArraysOES(1, &_cubeVAO);
    glDeleteVertexArraysOES(1, &_lampVAO);
    glDeleteBuffers(1, &_VBO);
}

/*
 法线矩阵(Normal Matrix) 为了将法向量也变换到世界坐标，但是不等比缩放的时候会破坏法向量，导致不垂直，这时候就需要法线矩阵
 在顶点着色器中，我们可以使用inverse和transpose函数自己生成这个法线矩阵，这两个函数对所有类型矩阵都有效。
 */
@end
