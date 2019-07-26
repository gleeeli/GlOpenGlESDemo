//
//  BaseViewController.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2018/9/11.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BaseViewController : UIViewController<GLKViewDelegate>
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *mEffect;
@property (nonatomic, strong) GLKView *kView;
@end
