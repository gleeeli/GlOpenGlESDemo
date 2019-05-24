//
//  DiffuseMapViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/24.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "DiffuseMapViewController.h"
#import "CommShader.h"
#import "CommViewCode.h"
#import "CommVertices.h"

@interface DiffuseMapViewController ()
@property (nonatomic , assign) GLuint diffuseMap;//贴图
@property (nonatomic , assign) GLuint specularMap;//采样镜面光贴图 处理钢铁边框被光照时表现较亮，木头被照则较暗
@property (nonatomic, assign) float nowX;
@property (nonatomic, assign) float directionAndSpeed;
@end

@implementation DiffuseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.directionAndSpeed = -0.01;
    self.nowX = 0.5f;
    [self setLightPost:self.nowX y:1.3f z:0.0f];
}

- (void)initShaderName {
    self.lightFrageShaderName = @"Diffuse_map_shaderf";
    self.lightVertexShaderName = @"Diffuse_map_shaderv";
}

- (void)handleVertex {
    NSLog(@"handle vertex");

    float vertices[288];
    float *tmp = getCubeAndNoramlAndMapVertices();
    for (int i = 0; i < 288; i++) {
        vertices[i] = tmp[i];
    }
    
    [self handleVBOVAO];
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //绑定立方体顶点
    [self createCubeVAO];
    
    // 绑定灯的顶点
    [self createlampVAO];
    self.diffuseMap = [self loadTextureWithName:@"container2"];
    self.specularMap = [self loadTextureWithName:@"container2_specular"];
    
    [self.lightShader setInt:"material.diffuse" intv:0];
    [self.lightShader setInt:"material.specular" intv:1];
}

- (void)createCubeVAO {
    glBindVertexArrayOES(self.cubeVAO);
    
    // cube position attribute
    GLuint position = glGetAttribLocation(self.lightShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
    
    //法向量，垂直于每个面
    GLuint normal = glGetAttribLocation(self.lightShader.shaderProgram, "aNormal");
    glVertexAttribPointer(normal, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(normal);
    
    // texture coord attribute
    GLuint aTexCoord = glGetAttribLocation(self.lightShader.shaderProgram, "aTexCoords");
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(6 * sizeof(float)));
    glEnableVertexAttribArray(aTexCoord);
}

/**
 创建灯的顶点数组对象，要是共用VAO 属性指针做出修改容易影响到灯
 */
- (void)createlampVAO {
    unsigned int lampVAO;
    glGenVertexArraysOES(1, &lampVAO);
    self.lampVAO = lampVAO;
    glBindVertexArrayOES(lampVAO);
    // 只需要绑定VBO不用再次设置VBO的数据，因为箱子的VBO数据中已经包含了正确的立方体顶点数据
    glBindBuffer(GL_ARRAY_BUFFER, self.VBO);
    // 设置灯立方体的顶点属性（对我们的灯来说仅仅只有位置数据）
    GLuint position = glGetAttribLocation(self.lamShader.shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
}

- (void)moveLambPosition {
    //函数体为空 则不移动光源
    if (self.nowX > 0.6 || self.nowX < -0.6) {
        self.directionAndSpeed = -self.directionAndSpeed;
    }
    
    self.nowX += self.directionAndSpeed;
    
    [self setLightPost:self.nowX y:1.3f z:0.0f];
}

- (void)setOtherLightShader {
    NSArray *array = [self getLightPos];
    float lx = [array[0] floatValue];
    float ly = [array[1] floatValue];
    float lz = [array[2] floatValue];
    glm::vec3 lightPos(lx, ly, lz);
    
    [self.lightShader setVec3:"light.position" vec3:lightPos];
    
    [self.lightShader setVec3:"light.ambient" x:0.5f y:0.5f z:0.5f];
    [self.lightShader setVec3:"light.diffuse" x:0.7f y:0.7f z:0.7f];
    [self.lightShader setVec3:"light.specular" x:1.0f y:1.0f z:1.0f];
    
    [self.lightShader setVec3:"material.specular" x:0.5f y:0.5f z:0.5f];
    [self.lightShader setFload:"material.shininess" floatv:64.0f];
}

//创建以及加载纹理
- (GLuint)loadTextureWithName:(NSString *)name{
    NSLog(@"加载纹理-loadTexture");
    //得到图片二进制
    float width;
    float height;
    GLubyte * spriteData = [CommViewCode getDataFromImg:name width:&width height:&height];

    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);

    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    float fw = width, fh = height;
    //第二个参数为纹理指定多级渐远纹理的级别，如果你希望单独手动设置每个多级渐远纹理的级别的话。这里我们填0，也就是基本级别。
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glGenerateMipmap(GL_TEXTURE_2D);

    free(spriteData);
    
    return texture;
}

- (void)drawHandleOther {
    glActiveTexture(GL_TEXTURE0);
    // bind Texture
    glBindTexture(GL_TEXTURE_2D, self.diffuseMap);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.specularMap);
}

@end
