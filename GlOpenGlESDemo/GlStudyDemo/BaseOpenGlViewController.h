//
//  BaseOpenGlViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseOpenGlViewController : GLKViewController
{
    int shaderProgram;
    unsigned int VAO;
    const char *vertexShaderSource;
    const char *fragmentShaderSource;
}
@property (nonatomic, copy) NSString *vsFileName;
@property (nonatomic, copy) NSString *fsFileName;

- (BOOL)initBaseShader;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
//链接着色器程序
- (BOOL)linkProgram:(GLuint)prog;
- (void)useProgram;
- (void)initBaseInfo;
/**
 获取运行时间
 */
- (NSTimeInterval)getTimeRuning;
@end

NS_ASSUME_NONNULL_END
