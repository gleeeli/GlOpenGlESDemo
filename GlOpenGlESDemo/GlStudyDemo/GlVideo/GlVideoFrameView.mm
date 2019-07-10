//
//  GlVideoFrameView.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/7/9.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "GlVideoFrameView.h"
#import "CommShader.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GlRenderRGBHandle.h"
#import "GlRenderYUVHandle.h"

@interface GlVideoFrameView()
@property (nonatomic, strong) CommShader *shader;
@property (nonatomic, strong) GlRenderHandle *renderHandle;
@end

@implementation GlVideoFrameView
{
    CAEAGLLayer* eaglLayer;
    EAGLContext* context;
    GLuint screenVBO;//屏幕的顶点缓冲对象
    GLuint screenVAO;//顶点数组
    
    //默认帧缓冲
    unsigned int defaultFramebuffer;
    unsigned int defaultColorRenderBuffer;
    unsigned int defaultDepthRenderBuffer;
    
    //渲染宽高
    GLint renderWidth;
    GLint renderHeight;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        
    }
    return self;
}

+ (Class)layerClass {
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (void)layoutSubviews {
    NSLog(@"执行：layoutSubviews");
    
    
    [self destoryFrameBuffer];
    [self initFrameBufferConfig];
}

- (void)setupLayer
{
    eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    eaglLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    context = [[EAGLContext alloc] initWithAPI:api];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES context");
        exit(1);
    }
    
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

//处理顶点缓冲
- (void)handleVertex {
    float vertices[] = {
        1.0, 1.0, 0,       1, 0,   // 右上               1, 0
        1.0, -1.0, 0,      1, 1,   // 右下               1, 1
        -1.0, -1.0, 0,     0, 1,   // 左下               0, 1
        -1.0, -1.0, 0,     0, 1,   // 左下               0, 1
        -1.0, 1.0, 0,      0, 0,   // 左上               0, 0
        1.0, 1.0, 0,       1, 0    // 右上               1, 0
    };
    
    glGenVertexArraysOES(1, &screenVAO);
    glGenBuffers(1, &screenVBO);
    glBindVertexArrayOES(screenVAO);
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), screenVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), &vertices, GL_STATIC_DRAW);
    
    //位置坐标
    GLuint apos = glGetAttribLocation(_shader.shaderProgram, "aPos");
    glEnableVertexAttribArray(apos);
    glVertexAttribPointer(apos, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    
    //纹理坐标
    GLuint aTexCoord = glGetAttribLocation(_shader.shaderProgram, "aTexCoord");
    glEnableVertexAttribArray(aTexCoord);
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    
    NSLog(@"处理顶点缓冲：VAO:%d,VBO:%d",screenVAO,screenVBO);
}

- (void)initFrameBufferConfig {
    [self setupRenderBuffer];
    [self setupDepthBuffer];
    [self setupFrameBuffer];
    [self checkFrameCompleteConfig];
}

/**
 销毁帧缓冲
 */
- (void)destoryFrameBuffer
{
    glDeleteFramebuffers(1, &defaultFramebuffer);
    defaultFramebuffer = 0;
    glDeleteRenderbuffers(1, &defaultColorRenderBuffer);
    defaultColorRenderBuffer = 0;
}

//设置帧缓冲
- (void)setupFrameBuffer {
    
    glGenFramebuffers(1, &defaultFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    //渲染缓冲
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, defaultColorRenderBuffer);
    //深度缓冲
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, defaultDepthRenderBuffer);
    
    //模板缓冲
    //    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, stencilRenderBuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, defaultColorRenderBuffer);
}

- (void)setupRenderBuffer {
    //生成颜色缓冲区
    glGenRenderbuffers(1, &defaultColorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, defaultColorRenderBuffer);
    //将可绘制对象的存储绑定到OpenGL ES renderbuffer对象。
    //要使OpenGL ES renderbuffer与CAEAGLLayer对象分离，请将drawable参数设置为nil即可将两者分离。
    if (![context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer]) {
        NSLog(@"ios renderbufferStorage failed");
    }
    
    //定存储在 renderbuffer 中图像的宽高以及颜色格式，并按照此规格为之分配存储空间
    //注意在iOS端 glRenderbufferStorage需要使用 renderbufferStorage:fromDrawable 函数来代替
    //    glRenderbufferStorage(GL_RENDERBUFFER,GL_RGBA,backingWidth,backingHeight);
    
    //获取渲染区的宽高
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderHeight);
    
    NSLog(@"渲染宽度：%d,高度:%d",renderWidth,renderHeight);
}

//设置深度缓冲
- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &defaultDepthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, defaultDepthRenderBuffer);
    //创建一个深度和模板渲染缓冲对象
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, renderWidth, renderHeight);
    
}

//检查帧缓冲的完整性
- (void)checkFrameCompleteConfig {
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status == GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"帧缓冲完整");
    }else if (status == GL_FRAMEBUFFER_UNSUPPORTED) {
        NSLog(@"帧缓冲fbo unsupported");
    } else {
        NSLog(@"帧缓冲Framebuffer Error:%d",status);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

/**
 更新一帧数据
 */
- (void)updateFrameTexture:(GlVideoFrameModel *)frameModel
{
    BOOL isReCompileShader = NO;
    if ([frameModel isKindOfClass:[GlVideoFrameYUVModel class]] && (![self.renderHandle isKindOfClass:[GlRenderYUVHandle class]] || self.renderHandle == nil)) {
        self.renderHandle = [[GlRenderYUVHandle alloc] init];
        isReCompileShader = YES;
        
    }else if ([frameModel isKindOfClass:[GlVideoFrameRGBModel class]] && (![self.renderHandle isKindOfClass:[GlRenderRGBHandle class]] || self.renderHandle == nil)) {
        self.renderHandle = [[GlRenderRGBHandle alloc] init];
        isReCompileShader = YES;
    }
    
    if (isReCompileShader) {//渲染方式改变，重新编译着色器
        self.shader = [[CommShader alloc] initWithvsFileName:self.renderHandle.shaderVName fsFileName:self.renderHandle.shaderFName];
        
        //处理顶点缓冲
        [self handleVertex];
    }
    
    //加载纹理
    if (frameModel) {
        [self.renderHandle loadTexture:frameModel];
    }
    
    [self render];
}

- (void)render {
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set current OpenGL context");
        return;
    }
    
    [self.shader useProgram];

    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    glEnable(GL_DEPTH_TEST);
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glViewport(0, 0, renderWidth, renderHeight);
    
    glBindVertexArrayOES(screenVAO);
    [self.renderHandle bindTexture:self.shader];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    //绑定当前颜色缓冲
    glBindRenderbuffer(GL_RENDERBUFFER, defaultColorRenderBuffer);
    //显示当前颜色缓冲
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
