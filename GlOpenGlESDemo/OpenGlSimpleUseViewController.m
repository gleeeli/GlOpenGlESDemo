//
//  OpenGlSimpleUseViewController.m
//  SFFmpegIOSStreamer
//
//  Created by 小柠檬 on 2018/9/10.
//  Copyright © 2018年 Lei Xiaohua. All rights reserved.
//

#import "OpenGlSimpleUseViewController.h"
#import <GLKit/GLKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface OpenGlSimpleUseViewController ()<GLKViewDelegate>
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *mEffect;
@property (nonatomic, strong) GLKView *kView;

@end

@implementation OpenGlSimpleUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConfig];
    [self uploadVertexArray];
    [self uploadTexture];
}

- (void)setupConfig{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *kView = [[GLKView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) context:self.context];
    self.kView = kView;
    kView.delegate = self;
    [self.view addSubview:kView];
    
    //kView.context = self.context;
    kView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:self.context];
}

- (void)uploadVertexArray{
    //顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
    GLfloat squareVertexData[] =
    {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    GLuint buffer;
    //申请一个标识符,生成一个顶点缓冲对象
    glGenBuffers(1, &buffer);
    //把标识符绑定到GL_ARRAY_BUFFER上
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    //把顶点数据从cpu内存复制到gpu内存
    /*它的第一个参数是目标缓冲的类型：顶点缓冲对象当前绑定到GL_ARRAY_BUFFER目标上。第二个参数指定传输数据的大小(以字节为单位)；用一个简单的sizeof计算出顶点数据大小就行。第三个参数是我们希望发送的实际数据。
     第四个参数指定了我们希望显卡如何管理给定的数据。它有三种形式：
     
     GL_STATIC_DRAW ：数据不会或几乎不会改变。
     GL_DYNAMIC_DRAW：数据会被改变很多。
     GL_STREAM_DRAW ：数据每次绘制时都会改变。*/
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    //是开启对应的顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置合适的格式从buffer里面读取数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
}

- (void)uploadTexture{
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
