//
//  FrameBufferView.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/7/5.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "FrameBufferView.h"
#import "CommShader.h"
#import "CommViewCode.h"
#import "CommHeader.h"


@implementation FrameBufferView
{
    GLuint fboTextId;
    CGSize frameBuffer1Size;
    GLuint vbo;
    GLuint vbo1;
    CommShader *shader;
    CommShader *shader1;
    GLuint textId;
    GLint width;
    GLint height;
}

+ (Class)layerClass {
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        frameBuffer1Size = CGSizeMake(320, 558);
        
        NSLog(@"屏幕宽度：%f,高度:%f",SCREEN_WIDTH,SCREEN_HEIGHT);
        [self setupLayer];
        [self setupContext];
        
        shader = [[CommShader alloc] initWithvsFileName:@"frame_shaderv" fsFileName:@"frame1_shaderf"];
        shader1 = [[CommShader alloc] initWithvsFileName:@"frame1_shaderv" fsFileName:@"frame1_shaderf"];
        
        [self setupVBO];
        [self setupVBO1];
        [self setupTexture];
    }
    return self;
}

- (void)layoutSubviews {
    NSLog(@"执行：layoutSubviews");
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    [self destoryRenderAndFrameBuffer];
    [self setupBuffer];
    [self setupBuffer1];
    
    [self render];
}

- (void)render {
    // 渲染到纹理贴图
    [shader1 useProgram];
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer1);//_frameBuffer1 == 2
    
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//    glViewport(0, 0, frameBuffer1Size.width * 2.0, frameBuffer1Size.height);
    glViewport(-160, 0, 320 * 2, 568);
    
    glBindVertexArrayOES(vbo1);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textId);
    glUniform1i(glGetUniformLocation(shader1.shaderProgram,"u_Texture"), 0);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    // 渲染到默认帧缓存
    [shader useProgram];
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);//_frameBuffer == 1
    
    glClearColor(0.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
//    glViewport(0, 0, 320, 568);
    
    NSLog(@"渲染：_frameBuffer:%d,_frameBuffer1：%d,",_frameBuffer,_frameBuffer1);
    NSLog(@"渲染视口宽度：%f,高度:%f",self.frame.size.width,self.frame.size.height);
    
    glBindVertexArrayOES(vbo);
    glBindTexture(GL_TEXTURE_2D, fboTextId);
    glUniform1i(glGetUniformLocation(shader.shaderProgram,"u_Texture"), 0);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES context");
        exit(1);
    }
    
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    
//    glEnable(GL_DEPTH_TEST);
}

- (void)setupBuffer {
    
    //渲染缓冲对象附件
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    // 创建深度缓冲区
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    
    // 窗口默认帧缓存
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status == GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"帧缓冲完整，_frameBuffer：%d",_frameBuffer);
    }else if (status == GL_FRAMEBUFFER_UNSUPPORTED) {
        NSLog(@"帧缓冲fbo unsupported");
    } else {
        NSLog(@"帧缓冲Framebuffer Error");
    }
}

- (void)setupDepthBuffer {
    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    //创建一个深度和模板渲染缓冲对象
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    
    //深度缓冲
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    
}

- (void)setupBuffer1 {
    glGenTextures(1, &fboTextId);
    glBindTexture(GL_TEXTURE_2D, fboTextId);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    // 生成纹理，数据给nil
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, frameBuffer1Size.width, frameBuffer1Size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    // 生成帧缓存
    glGenFramebuffers(1, &_frameBuffer1);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer1);
    // 将纹理附件附加到帧缓冲上
    glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, fboTextId, 0);
    
//    [self setupDepthBuffer];
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status == GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"帧缓冲完整，_frameBuffer1：%d",_frameBuffer1);
    }else if (status == GL_FRAMEBUFFER_UNSUPPORTED) {
        NSLog(@"帧缓冲fbo unsupported");
    } else {
        NSLog(@"帧缓冲Framebuffer Error");
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}


- (void)setupVBO {
    float vertices[] = {
        0.5, 0.5, -1,       1, 1,   // 右上               1, 0
        0.5, -0.5, -1,      1, 0,   // 右下               1, 1
        -0.5, -0.5, -1,     0, 0,   // 左下               0, 1
        -0.5, -0.5, -1,     0, 0,   // 左下               0, 1
        -0.5, 0.5, -1,      0, 1,   // 左上               0, 0
        0.5, 0.5, -1,       1, 1    // 右上               1, 0
    };
    
    glGenBuffers(1, &vbo);
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), &vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLuint(glGetAttribLocation(shader.shaderProgram, "aPos")));
    glVertexAttribPointer(GLuint(glGetAttribLocation(shader.shaderProgram, "aPos")), 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    
    glEnableVertexAttribArray(GLuint(glGetAttribLocation(shader.shaderProgram, "aTexCoord")));
    glVertexAttribPointer(GLuint(glGetAttribLocation(shader.shaderProgram, "aTexCoord")), 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
}

- (void)setupVBO1 {
    float vertices1[] = {
        0.5, 0.5, -1,       1.0, 1.0,   // 右上               1, 0
        0.5, -0.5, -1,      1.0, 0.0,   // 右下               1, 1
        -0.5, -0.5, -1,     0.0, 0.0,   // 左下               0, 1
        -0.5, -0.5, -1,     0.0, 0.0,   // 左下               0, 1
        -0.5, 0.5, -1,      0.0, 1.0,   // 左上               0, 0
        0.5, 0.5, -1,       1.0, 1.0    // 右上               1, 0
    };
    
    glGenBuffers(1, &vbo1);
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo1);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices1), &vertices1, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLuint(glGetAttribLocation(shader1.shaderProgram, "aPos")));
    glVertexAttribPointer(GLuint(glGetAttribLocation(shader1.shaderProgram, "aPos")), 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    
    glEnableVertexAttribArray(GLuint(glGetAttribLocation(shader1.shaderProgram, "aTexCoord")));
    glVertexAttribPointer(GLuint(glGetAttribLocation(shader1.shaderProgram, "aTexCoord")), 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
}

- (void)setupTexture {
    textId = [self loadTextureWithName:@"back" isRepeate:NO];
}

- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

//创建以及加载纹理
- (GLuint)loadTextureWithName:(NSString *)name isRepeate:(BOOL)isRepeat{
    NSLog(@"加载纹理-loadTexture");
    //得到图片二进制
    float width;
    float height;
    GLubyte * spriteData = [CommViewCode getDataFromImg:name width:&width height:&height];
    
    NSLog(@"图片宽度：%f,高度:%f",width,height);
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
    glDeleteBuffers(1, &vbo);
    glDeleteBuffers(1, &vbo1);
    glDeleteTextures(1, &textId);
    glDeleteTextures(1, &fboTextId);
    
    glDeleteProgram(shader.shaderProgram);
    glDeleteProgram(shader1.shaderProgram);
}
@end


/*
 一个完整的帧缓冲需要满足以下的条件：
 
 附加至少一个缓冲（颜色、深度或模板缓冲）。
 至少有一个颜色附件(Attachment)。
 所有的附件都必须是完整的（保留了内存）。
 每个缓冲都应该有相同的样本数。
 
 调用glCheckFramebufferStatus，检查帧缓冲是否完整。它将会检测当前绑定的帧缓冲，并返回规范中这些值的其中之一。如果它返回的是GL_FRAMEBUFFER_COMPLETE，帧缓冲就是完整的了
 */
