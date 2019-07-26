//
//  BaseOpenGlViewController.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/3/4.
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
@property (nonatomic , strong) EAGLContext* mContext;

- (BOOL)initBaseShader;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
//链接着色器程序
- (BOOL)linkProgram:(GLuint)prog;
- (void)useProgram;
- (void)initBaseInfo;
- (void)setupOpenGlBase;

/**
 获取运行时间
 */
- (NSTimeInterval)getTimeRuning;

/**
 获取图片二进制 以及宽高
 
 @param imgName 图片名
 */
- (GLubyte *)getDataFromImg:(NSString *)imgName width:(float *)width height:(float *)height;


@end

NS_ASSUME_NONNULL_END
