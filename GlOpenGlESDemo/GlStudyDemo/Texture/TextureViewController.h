//
//  TextureViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "BaseOpenGlViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextureViewController : BaseOpenGlViewController
- (void)handleVertex;
/**
 获取图片二进制 以及宽高
 
 @param imgName 图片名
 */
- (GLubyte *)getDataFromImg:(NSString *)imgName width:(float *)width height:(float *)height;

//创建以及加载纹理
- (void)loadTexture;
@end

NS_ASSUME_NONNULL_END
