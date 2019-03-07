//
//  TwoTextureViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/5.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "TwoTextureViewController.h"

@interface TwoTextureViewController ()

@end

@implementation TwoTextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)initBaseInfo {
    self.vsFileName = @"two_texture_shaderv";
    self.fsFileName = @"two_texture_shaderf";
}

//创建以及加载纹理
- (void)loadTexture {
    
    //得到图片二进制
    float width;
    float height;
    GLubyte * spriteData = [self getDataFromImg:@"fengjing" width:&width height:&height];
    
    glGenTextures(1, &_myTexture1);
    glBindTexture(GL_TEXTURE_2D, self.myTexture1);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    //第二个参数为纹理指定多级渐远纹理的级别，如果你希望单独手动设置每个多级渐远纹理的级别的话。这里我们填0，也就是基本级别。
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    
    // texture 2
    float width2;
    float height2;
    //awesomeface quan qingwa2
    GLubyte * spriteData2 = [self getDataFromImg:@"awesomeface" width:&width2 height:&height2];
    
    glGenTextures(1, &_myTexture2);
    glBindTexture(GL_TEXTURE_2D, self.myTexture2);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);    // set texture wrapping to GL_REPEAT (default wrapping method)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    float fw2 = width2,fh2 = height2;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw2, fh2, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData2);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    free(spriteData);
    free(spriteData2);
    
    [self useProgram];
    
    //使用glUniform1i设置每个采样器的方式告诉OpenGL每个着色器采样器属于哪个纹理单元
    glUniform1i(glGetUniformLocation(shaderProgram, "texture1"), 0);
    glUniform1i(glGetUniformLocation(shaderProgram, "texture2"), 1);
    
    
    
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
    glBindVertexArrayOES(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}
@end
