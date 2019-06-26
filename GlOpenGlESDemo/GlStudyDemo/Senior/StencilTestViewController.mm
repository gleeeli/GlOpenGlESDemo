//
//  StencilTestViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/6/26.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "StencilTestViewController.h"
#import "CommShader.h"
#import "CommViewCode.h"
#import "CommVertices.h"
#import "CommCamera.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"

@interface StencilTestViewController ()
@property (nonatomic, strong) CommShader *baseShader;
@property (nonatomic, strong) CommShader *singleShader;
@end

@implementation StencilTestViewController
{
    CommCamera *camera;
    GLuint cubeTexture;
    GLuint planeTexture;
    unsigned int cubeVAO;
    unsigned int planeVAO;
    unsigned int cubeVBO;
    unsigned int planeVBO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupOpenGlBase];
    
    //    glDepthFunc(GL_ALWAYS);
    //GL_LESS:在片段深度值小于缓冲的深度值时通过测试
    glDepthFunc(GL_LESS);
    
    //OpenGL允许我们禁用深度缓冲的写入
    //    glDepthMask(GL_FALSE);
    
    [self openStencil];
    
    //带环境光，漫反射的光源世界
    self.baseShader = [[CommShader alloc] initWithvsFileName:@"depth_test_shaderv" fsFileName:@"depth_test_shaderf"];
    self.singleShader = [[CommShader alloc] initWithvsFileName:@"depth_test_shaderv" fsFileName:@"stencil_test_shaderf"];
    
    //手势 摄像头控制，此处设置摄像头的位置,注意不是物体坐标
    camera = [[CommCamera alloc] initWithBackView:self.view cameraPos:glm::vec3(0.0f, 1.5f, 3.0f) cameraUp:glm::vec3(0.0f, 1.0f,  0.0f) yaw:-90.0 pitch:0.3f];
    
    [self handleVertex];
}

//启用模板测试，并设置测试通过或失败时的行为：
- (void)openStencil {
    glEnable(GL_STENCIL_TEST);
//    glStencilMask(GL_TRUE);
//    glStencilFunc(GL_EQUAL, 1, 0xFF);
    glStencilFunc(GL_NOTEQUAL, 1, 0xFF);
    glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
}

- (void)handleVertex {
    NSLog(@"handle vertex");
    
    float cubeVertices[180];
    float *tmpCube = getCubeAndTextureVertices();
    for (int i = 0; i < 180; i++) {
        cubeVertices[i] = tmpCube[i];
    }
    
    float planeVertices[30];
    float *tmpPlan = getPlanVertices();
    for (int i = 0; i < 30; i++) {
        planeVertices[i] = tmpPlan[i];
    }
    
    // cube VAO
    glGenVertexArraysOES(1, &cubeVAO);
    glGenBuffers(1, &cubeVBO);
    glBindVertexArrayOES(cubeVAO);
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertices), &cubeVertices, GL_STATIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.baseShader.shaderProgram, "aPos");
    GLuint aTexCoord = glGetAttribLocation(self.baseShader.shaderProgram, "aTexCoord");
    
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    
    glEnableVertexAttribArray(aTexCoord);
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glBindVertexArrayOES(0);
    
    
    // plane VAO
    glGenVertexArraysOES(1, &planeVAO);
    glGenBuffers(1, &planeVBO);
    glBindVertexArrayOES(planeVAO);
    glBindBuffer(GL_ARRAY_BUFFER, planeVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(planeVertices), &planeVertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    
    glEnableVertexAttribArray(aTexCoord);
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glBindVertexArrayOES(0);
    
    //创建纹理
    glActiveTexture(GL_TEXTURE0);
    //isRepeate:两个纹理时 必需设置不同，不知原因？？？
    cubeTexture = [self loadTextureWithName:@"container2" isRepeate:NO];
    planeTexture = [self loadTextureWithName:@"bricks" isRepeate:YES];
    
    //    cubeTexture = [TextureHelper createTexture:@"container3.png" isPVR:NO];
    //    planeTexture = [TextureHelper createTexture:@"bricks.png" isPVR:NO];
    
    [self.baseShader useProgram];
    [self.baseShader setInt:"texture1" intv:0];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    //GLboolean result = glIsEnabled(GL_STENCIL_TEST);
    
    //手势需要获取绘制每一帧的时长 减少不同设备的差异
    [camera handleDelay];
    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    //深度测试清除缓存
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    // set uniforms
    
    glm::mat4 model = glm::mat4(1.0f);
    glm::mat4 view_camer = [camera GetViewMatrix];
    glm::mat4 projection = glm::perspective(glm::radians(camera.zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    
    [self.singleShader useProgram];
    [self.singleShader setMat4:"view" mat4:view_camer];
    [self.singleShader setMat4:"projection" mat4:projection];
    
    [self.baseShader useProgram];
    [self.baseShader setMat4:"view" mat4:view_camer];
    [self.baseShader setMat4:"projection" mat4:projection];
    
    //地板关闭模板测试，不让其写入缓冲
    glStencilMask(GL_FALSE);
    // floor
    glBindVertexArrayOES(planeVAO);
    glBindTexture(GL_TEXTURE_2D, planeTexture);
    
    [self.baseShader setMat4:"model" mat4:glm::mat4(1.0f)];
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArrayOES(0);
    
    //第一次渲染立方体，让模板测试全部通过，写入模板缓冲
    glStencilFunc(GL_ALWAYS, 1, 1);//// 所有的片段都应该更新模板缓冲
    glStencilMask(GL_TRUE);//// 启用模板缓冲写入
    // cubes
    glBindVertexArrayOES(cubeVAO);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, cubeTexture);
    
    model = glm::translate(model, glm::vec3(0.0f, 0.0f, -1.0f));
    [self.baseShader setMat4:"model" mat4:model];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(2.0f, 0.0f, 0.0f));
    [self.baseShader setMat4:"model" mat4:model];
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    
    //第二次渲染，放大所有立方体
    
    // 2nd. render pass: now draw slightly scaled versions of the objects, this time disabling stencil writing.
    // Because the stencil buffer is now filled with several 1s. The parts of the buffer that are 1 are not drawn, thus only drawing
    // the objects' size differences, making it look like borders.
    // -----------------------------------------------------------------------------------------------------------------------------
    //模板函数设置为GL_NOTEQUAL，它会保证我们只绘制箱子上模板值不为1的部分，即只绘制箱子在之前绘制的箱子之外的部分
    glStencilFunc(GL_NOTEQUAL, 1, 1);
    glStencilMask(GL_FALSE);// // 禁止模板缓冲的写入
    glDisable(GL_DEPTH_TEST);//禁用了深度测试，让放大的箱子，即边框，不会被地板所覆盖。
    [self.singleShader useProgram];
    
    float scale = 1.1;
    // cubes
    glBindVertexArrayOES(cubeVAO);
    glBindTexture(GL_TEXTURE_2D, cubeTexture);
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(0.0f, 0.0f, -1.0f));
    model = glm::scale(model, glm::vec3(scale, scale, scale));
    [self.singleShader setMat4:"model" mat4:model];
    glDrawArrays(GL_TRIANGLES, 0, 36);
//    model = glm::mat4(1.0f);
//    model = glm::translate(model, glm::vec3(2.0f, 0.0f, 0.0f));
//    model = glm::scale(model, glm::vec3(scale, scale, scale));
//    [self.singleShader setMat4:"model" mat4:model];
//    glDrawArrays(GL_TRIANGLES, 0, 36);
    glBindVertexArrayOES(0);
    glStencilMask(GL_TRUE);
    glEnable(GL_DEPTH_TEST);
   
}

//创建以及加载纹理
- (GLuint)loadTextureWithName:(NSString *)name isRepeate:(BOOL)isRepeat{
    NSLog(@"加载纹理-loadTexture");
    //得到图片二进制
    float width;
    float height;
    GLubyte * spriteData = [CommViewCode getDataFromImg:name width:&width height:&height];
    
    
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    if (isRepeat) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        
    }else {
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    }
    
    int fw = width, fh = height;
    GLenum format;
    //    format = GL_RED;
    format = GL_RGBA;
    //        format = GL_RGB;
    //第二个参数为纹理指定多级渐远纹理的级别，如果你希望单独手动设置每个多级渐远纹理的级别的话。这里我们填0，也就是基本级别。
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, format, fw, fh, 0, format, GL_UNSIGNED_BYTE, spriteData);
    glBindTexture(GL_TEXTURE_2D, 0);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    
    free(spriteData);
    
    return texture;
}

- (void)dealloc {
    glDeleteVertexArraysOES(1, &cubeVAO);
    glDeleteVertexArraysOES(1, &planeVAO);
    glDeleteBuffers(1, &cubeVBO);
    glDeleteBuffers(1, &planeVBO);
}

@end


/*
 
 glStencilOp(GLenum sfail, GLenum dpfail, GLenum dppass)一共包含三个选项，我们能够设定每个选项应该采取的行为：
 
 sfail：模板测试失败时采取的行为。
 dpfail：模板测试通过，但深度测试失败时采取的行为。
 dppass：模板测试和深度测试都通过时采取的行为。
 
 
 行为    描述
 GL_KEEP    保持当前储存的模板值
 GL_ZERO    将模板值设置为0
 GL_REPLACE    将模板值设置为glStencilFunc函数设置的ref值
 GL_INCR    如果模板值小于最大值则将模板值加1
 GL_INCR_WRAP    与GL_INCR一样，但如果模板值超过了最大值则归零
 GL_DECR    如果模板值大于最小值则将模板值减1
 GL_DECR_WRAP    与GL_DECR一样，但如果模板值小于0则将其设置为最大值
 GL_INVERT    按位翻转当前的模板缓冲值
 */
