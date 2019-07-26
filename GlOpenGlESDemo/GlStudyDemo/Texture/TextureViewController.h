//
//  TextureViewController.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "BaseOpenGlViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextureViewController : BaseOpenGlViewController
@property (nonatomic , assign) GLuint myTexture;

- (void)handleVertex;

//创建以及加载纹理
- (void)loadTexture;
@end

NS_ASSUME_NONNULL_END
