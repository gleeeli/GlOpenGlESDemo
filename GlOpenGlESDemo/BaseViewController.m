//
//  BaseViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2018/9/11.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConfig];
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
