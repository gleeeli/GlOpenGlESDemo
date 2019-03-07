//
//  TwoTextureViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/5.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "TextureViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TwoTextureViewController : TextureViewController
@property (nonatomic , assign) GLuint myTexture1;
@property (nonatomic , assign) GLuint myTexture2;
@end

NS_ASSUME_NONNULL_END
