//
//  BaseCoordinateSysViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/17.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "BaseCoordinateSysViewController.h"

@interface BaseCoordinateSysViewController ()

@end

@implementation BaseCoordinateSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageName = @"fengjing";
    [self handleVertex];
}

- (void)initBaseInfo {
    self.vsFileName = @"simple3D_shaderv";
    self.fsFileName = @"simple3D_shaderf";
}

- (void)handleVertex {
    NSLog(@"handle vertex");
    
}

//创建以及加载纹理
- (void)loadTexture {
    NSLog(@"加载纹理-loadTexture");
    //得到图片二进制
    float width;
    float height;
    GLubyte * spriteData = [self getDataFromImg:self.imageName width:&width height:&height];
    
    
    glGenTextures(1, &_myTexture);
    glBindTexture(GL_TEXTURE_2D, self.myTexture);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    //第二个参数为纹理指定多级渐远纹理的级别，如果你希望单独手动设置每个多级渐远纹理的级别的话。这里我们填0，也就是基本级别。
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    free(spriteData);
}

- (BOOL)initBaseShader {
    
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    //创建着色器程序
    shaderProgram = glCreateProgram();
    
    // 创建 编译顶点着色器
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:self.vsFileName ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // 创建 编译片段着色器
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:self.fsFileName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(shaderProgram, vertShader);
    glAttachShader(shaderProgram, fragShader);
    
    // 链接程序
    if (![self linkProgram:shaderProgram]) {
        NSLog(@"Failed to link program: %d", shaderProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (shaderProgram) {
            glDeleteProgram(shaderProgram);
            shaderProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(shaderProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(shaderProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

@end
