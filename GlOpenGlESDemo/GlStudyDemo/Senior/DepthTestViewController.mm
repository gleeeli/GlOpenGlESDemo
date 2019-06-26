//
//  DepthTestViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/6/25.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "DepthTestViewController.h"
#import "CommShader.h"
#import "CommViewCode.h"
#import "CommVertices.h"
#import "CommCamera.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#import "stb_image.h"
#import "TextureHelper.h"

@interface DepthTestViewController ()
@property (nonatomic, strong) CommShader *baseShader;
@end

@implementation DepthTestViewController
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
    
    //带环境光，漫反射的光源世界
    self.baseShader = [[CommShader alloc] initWithvsFileName:@"depth_test_shaderv" fsFileName:@"depth_test_shaderf"];
    
    //手势 摄像头控制，此处设置摄像头的位置,注意不是物体坐标
    camera = [[CommCamera alloc] initWithBackView:self.view cameraPos:glm::vec3(0.0f, 1.5f, 3.0f) cameraUp:glm::vec3(0.0f, 1.0f,  0.0f) yaw:-90.0 pitch:0.3f];
    
    [self handleVertex];
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
    //手势需要获取绘制每一帧的时长 减少不同设备的差异
    [camera handleDelay];
    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    //深度测试清除缓存
    glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);
    
    [self.baseShader useProgram];
    glm::mat4 model = glm::mat4(1.0f);
    glm::mat4 view_camer = [camera GetViewMatrix];
    glm::mat4 projection = glm::perspective(glm::radians(camera.zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    [self.baseShader setMat4:"view" mat4:view_camer];
    [self.baseShader setMat4:"projection" mat4:projection];

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
    // floor
    glBindVertexArrayOES(planeVAO);
    glBindTexture(GL_TEXTURE_2D, planeTexture);
    
    [self.baseShader setMat4:"model" mat4:glm::mat4(1.0f)];
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArrayOES(0);
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
