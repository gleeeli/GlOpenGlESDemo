//
//  LightColorsViewController.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/5/16.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "BaseOpenGl3DViewController.h"

@class CommShader;
@interface LightColorsViewController : BaseOpenGl3DViewController
@property (nonatomic, strong) CommShader *lightShader;
 @property (nonatomic, strong) CommShader *lamShader;
@property (nonatomic, copy) NSString *lightFrageShaderName;//光的片段着色器
@property (nonatomic, copy) NSString *lightVertexShaderName;//顶点着色器
@property (nonatomic, assign) unsigned int cubeVAO;
@property (nonatomic, assign) unsigned int lampVAO;
@property (nonatomic, assign) unsigned int VBO;

- (void)initShaderName;
- (void)handleVertex;
//VBO 不知道怎么提到外部初始化 暂时这样
- (void)handleVBOVAO;
- (void)createCubeVAO;
/**
 创建灯的顶点数组对象，要是共用VAO 属性指针做出修改容易影响到灯
 */
- (void)createlampVAO;
- (void)setOtherLightShader;
- (NSTimeInterval)getRunTime;
/**
 移动灯
 */
-(void)moveLambPosition;

- (NSArray *)getLightPos;
- (void)drawHandleOther;
/**
 设置光源位置
 */
- (void)setLightPost:(float)x y:(float)y z:(float)z;
@end
