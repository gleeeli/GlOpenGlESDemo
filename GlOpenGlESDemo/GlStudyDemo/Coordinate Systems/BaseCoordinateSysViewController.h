//
//  BaseCoordinateSysViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/4/17.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "BaseOpenGlViewController.h"


@interface BaseCoordinateSysViewController : BaseOpenGlViewController
@property (nonatomic , assign) GLuint myTexture;
@property (nonatomic, copy) NSString *imageName;
- (void)handleVertex;

//创建以及加载纹理
- (void)loadTexture;
@end
