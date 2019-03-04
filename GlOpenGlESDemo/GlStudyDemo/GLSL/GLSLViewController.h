//
//  GLSLViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLSLViewController : GLKViewController
{
    int shaderProgram;
    unsigned int VAO;
    const char *vertexShaderSource;
    const char *fragmentShaderSource;
}

/**
 初始化着色器程序字符串
 */
- (void)initShaderString;

- (void)initBaseShader;
/**
 开始处理顶点数据
 */
- (void)handleVertex;
@end

NS_ASSUME_NONNULL_END
