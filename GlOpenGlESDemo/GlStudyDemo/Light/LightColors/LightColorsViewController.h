//
//  LightColorsViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/16.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "BaseOpenGl3DViewController.h"

@class CommShader;
@interface LightColorsViewController : BaseOpenGl3DViewController
@property (nonatomic, strong) CommShader *lightShader;
@property (nonatomic, copy) NSString *lightFrageShaderName;//光的片段着色器

- (void)initShaderName;
- (void)setOtherLightShader;
- (NSTimeInterval)getRunTime;
/**
 移动灯
 */
-(void)moveLambPosition;

- (NSArray *)getLightPos;
@end
