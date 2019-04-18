//
//  BaseOpenGlViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "BaseOpenGlViewController.h"

@interface BaseOpenGlViewController ()
@property (nonatomic, assign) NSTimeInterval startTime;
@end

@implementation BaseOpenGlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseInfo];
    [self setupOpenGlBase];
    BOOL rShader = [self initBaseShader];
    if (rShader) {
        NSLog(@"shader success");
    }else {
        NSLog(@"error: shader failder");
    }
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)initBaseInfo {
    
}

- (void)setupOpenGlBase {
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //2.0，还有1.0和3.0
    
    if (!self.mContext) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    //此句与深度测试有关
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.mContext];
}

- (BOOL)initBaseShader {
    return NO;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

//链接着色器程序
- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)useProgram {
    glUseProgram(shaderProgram);
}

/**
 获取运行时间
 */
- (NSTimeInterval)getTimeRuning {
    return [[NSDate date]timeIntervalSince1970] - self.startTime;
}

/**
 获取图片二进制 以及宽高
 
 @param imgName 图片名
 */
- (GLubyte *)getDataFromImg:(NSString *)imgName width:(float *)width height:(float *)height {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:imgName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", imgName);
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width_s = CGImageGetWidth(spriteImage);
    size_t height_s = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width_s * height_s * 4, sizeof(GLubyte));////rgba共4个byte
    
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width_s, height_s,
                                                       8,//内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
                                                       width_s*4,//bitmap的每一行在内存所占的比特数
                                                       CGImageGetColorSpace(spriteImage),//bitmap上下文使用的颜色空间。
                                                       kCGImageAlphaPremultipliedLast);//指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width_s, height_s), spriteImage);
    CGContextRelease(spriteContext);
    *width = width_s;
    *height = height_s;
    
    return spriteData;
}

@end
