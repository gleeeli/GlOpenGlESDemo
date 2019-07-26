//
//  FrameBufferViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/6/27.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "FrameBufferViewController.h"
#import "CommShader.h"
#import "CommViewCode.h"
#import "CommVertices.h"
#import "CommCamera.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"

@interface FrameBufferViewController ()
@property (nonatomic, strong) CommShader *baseShader;
@property (nonatomic, strong) CommShader *screenShader;
@end

@implementation FrameBufferViewController
{
    CommCamera *camera;
    CAEAGLLayer *layer;
    GLuint cubeTexture;
    GLuint planeTexture;
    unsigned int cubeVAO;
    unsigned int planeVAO;
    unsigned int cubeVBO;
    unsigned int planeVBO;
    unsigned int quadVAO, quadVBO;
    unsigned int textureColorbuffer;
    unsigned int framebuffer;
    unsigned int renderbuff;
    unsigned int colorrenderbuff;
    unsigned int depthRenderBuffer;
    unsigned int stencilRenderBuffer;
    
    unsigned int defaultFramebuffer;
    unsigned int defaultColorRenderBuffer;
    unsigned int defaultDepthRenderBuffer;
    
    GLint backingWidth;
    GLint backingHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupOpenGlBase];
    
    //GL_LESS:在片段深度值小于缓冲的深度值时通过测试
    glDepthFunc(GL_LESS);
    
    //带环境光，漫反射的光源世界
    self.baseShader = [[CommShader alloc] initWithvsFileName:@"frame_buffer_shaderv" fsFileName:@"frame_buffer_shaderf"];
    self.screenShader = [[CommShader alloc] initWithvsFileName:@"fb_screen_shaderv" fsFileName:@"fb_screen_shaderf"];
    
    //手势 摄像头控制，此处设置摄像头的位置,注意不是物体坐标
    camera = [[CommCamera alloc] initWithBackView:self.view cameraPos:glm::vec3(0.0f, 1.5f, 3.0f) cameraUp:glm::vec3(0.0f, 1.0f,  0.0f) yaw:-90.0 pitch:0.3f];
    
    [self handleVertex];
    
    [self createLayer];
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
    
    float quadVertices[24];
    float *tmpQuad = getQuadVertices();
    for (int i = 0; i < 24; i++) {
        quadVertices[i] = tmpQuad[i];
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
    
    // screen quad VAO
    GLuint quadPosition = glGetAttribLocation(self.screenShader.shaderProgram, "aPos");
    GLuint quadTexCoord = glGetAttribLocation(self.screenShader.shaderProgram, "aTexCoord");
    
    glGenVertexArraysOES(1, &quadVAO);
    glGenBuffers(1, &quadVBO);
    glBindVertexArrayOES(quadVAO);
    glBindBuffer(GL_ARRAY_BUFFER, quadVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), &quadVertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(quadPosition);
    glVertexAttribPointer(quadPosition, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(quadTexCoord);
    glVertexAttribPointer(quadTexCoord, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), (void*)(2 * sizeof(float)));
    
    //创建纹理
    //isRepeate:两个纹理时 必需设置不同，不知原因？？？
    cubeTexture = [self loadTextureWithName:@"container2" isRepeate:NO];
    planeTexture = [self loadTextureWithName:@"bricks" isRepeate:YES];
    
    [self.baseShader useProgram];
    [self.baseShader setInt:"texture1" intv:0];
    
    [self.screenShader useProgram];
    [self.screenShader setInt:"screenTexture" intv:0];

}

- (void)createLayer {
    layer = [[CAEAGLLayer alloc] init];
    layer.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-200);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    layer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    [self.view.layer addSublayer:layer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self destoryRenderAndFrameBuffer];
    [self setupRenderBuffer];
    [self setupDepthBuffer];
//    [self setupStencil];
    [self setupFrameBuffer];
    
    [self checkFrameCompleteConfig];
    [self setupTexture];
}

- (void)setupFrameBuffer {
    
    glGenFramebuffers(1, &defaultFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    //渲染缓冲
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorrenderbuff);
    //深度缓冲
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    
    //模板缓冲
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, stencilRenderBuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorrenderbuff);
}

- (void)setupRenderBuffer {
    //生成颜色缓冲区
    glGenRenderbuffers(1, &colorrenderbuff);
    glBindRenderbuffer(GL_RENDERBUFFER, colorrenderbuff);
    //将可绘制对象的存储绑定到OpenGL ES renderbuffer对象。
    //要使OpenGL ES renderbuffer与CAEAGLLayer对象分离，请将drawable参数设置为nil即可将两者分离。
    if (![self.mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer]) {
        NSLog(@"ios renderbufferStorage failed");
    }
    
    //定存储在 renderbuffer 中图像的宽高以及颜色格式，并按照此规格为之分配存储空间
    //注意在iOS端 glRenderbufferStorage需要使用 renderbufferStorage:fromDrawable 函数来代替
    //    glRenderbufferStorage(GL_RENDERBUFFER,GL_RGBA,backingWidth,backingHeight);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    NSLog(@"渲染宽度：%d,高度:%d",backingWidth,backingHeight);
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    //创建一个深度和模板渲染缓冲对象
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
    
}

- (void)setupStencil {
    glGenRenderbuffers(1, &stencilRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, stencilRenderBuffer);
    //创建一个深度和模板渲染缓冲对象
    glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, backingWidth, backingHeight);
}

- (void)setupTexture {
    // 创建纹理附件
    glGenTextures(1, &textureColorbuffer);
    glBindTexture(GL_TEXTURE_2D, textureColorbuffer);
    //网上加的两行
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, SCREEN_WIDTH, SCREEN_HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    //将纹理附件绑定到帧缓冲
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureColorbuffer, 0);
    
    glGenRenderbuffers(1, &defaultDepthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, defaultDepthRenderBuffer);
    //创建一个深度和模板渲染缓冲对象
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);

    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, defaultDepthRenderBuffer);
    
    [self checkFrameCompleteConfig];
}

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

- (void)beginRender
{
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
}

- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &framebuffer);
    framebuffer = 0;
    glDeleteRenderbuffers(1, &colorrenderbuff);
    colorrenderbuff = 0;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [camera handleDelay];

    [self.baseShader useProgram];
    // bind to framebuffer and draw scene as we normally would to color texture
    [self beginRender];
    glEnable(GL_DEPTH_TEST); // enable depth testing (is disabled for rendering screen-space quad)
    
    // make sure we clear the framebuffer's content
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glViewport(0, 0, backingWidth, backingHeight);
    
    glm::mat4 model = glm::mat4(1.0f);
    glm::mat4 view_camer = [camera GetViewMatrix];
    glm::mat4 projection = glm::perspective(glm::radians(camera.zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    [self.baseShader setMat4:"view" mat4:view_camer];
    [self.baseShader setMat4:"projection" mat4:projection];
    // cubes
    glBindVertexArrayOES(cubeVAO);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, cubeTexture);//纹理单元0绑定立方体纹理
    model = glm::translate(model, glm::vec3(-1.0f, 0.0f, -1.0f));
    [self.baseShader setMat4:"model" mat4:model];
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    
    model = glm::mat4(1.0f);
    model = glm::translate(model, glm::vec3(2.0f, 0.0f, 0.0f));
    [self.baseShader setMat4:"model" mat4:model];
    glDrawArrays(GL_TRIANGLES, 0, 36);
    // floor
    glBindVertexArrayOES(planeVAO);
    glBindTexture(GL_TEXTURE_2D, planeTexture);//立方体画完了，纹理单元0空闲，继续绑定底板图片
    [self.baseShader setMat4:"model" mat4:glm::mat4(1.0f)];
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArrayOES(0);
    
    //绑定到默认帧缓冲，苹果渲染到Core Animation层必须通过color renderbuffer（颜色渲染缓冲）
   [self.screenShader useProgram];
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    glDisable(GL_DEPTH_TEST);

    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glBindVertexArrayOES(quadVAO);
    //将纹理附件绑定到默认的0号纹理单元
    glBindTexture(GL_TEXTURE_2D, textureColorbuffer);    // use the color attachment texture as the texture of the quad plane

     [self.screenShader setInt:"screenTexture" intv:0];

    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    //绑定当前颜色缓冲，因为上面最后一次绑定的是深度渲染缓冲，所以这里必须更换
    glBindRenderbuffer(GL_RENDERBUFFER, colorrenderbuff);
    //显示当前颜色缓冲
    [self.mContext presentRenderbuffer:GL_RENDERBUFFER];
    
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
    
    glDeleteVertexArraysOES(1, &quadVAO);
    glDeleteBuffers(1, &planeVBO);
    glDeleteBuffers(1, &quadVBO);
}

/*
由于渲染缓冲对象通常都是只写的，它们会经常用于深度和模板附件，因为大部分时间我们都不需要从深度和模板缓冲中读取值，只关心深度和模板测试。
 我们需要深度和模板值用于测试，但不需要对它们进行采样，所以渲染缓冲对象非常适合它们。
 
 创建一个深度和模板渲染缓冲对象
 glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, 800, 600);
 
 如果你不需要从一个缓冲中采样数据，那么对这个缓冲使用渲染缓冲对象会是明智的选择。如果你需要从缓冲中采样颜色或深度值等数据，那么你应该选择纹理附件。
*/

@end
