//
//  BaseOpenGl3DViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "BaseOpenGl3DViewController.h"


@interface BaseOpenGl3DViewController ()

@end

@implementation BaseOpenGl3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    [EAGLContext setCurrentContext:self.mContext];
    
    [self openDepth];
}

//开启深度测试
- (void)openDepth {
    glEnable(GL_DEPTH_TEST);
}

@end
