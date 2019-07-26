//
//  GlRenderHandle.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/7/10.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlVideoFrameModel.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CommShader.h"

@interface GlRenderHandle : NSObject
@property (nonatomic, strong) NSString *shaderVName;//顶点着色器名
@property (nonatomic, strong) NSString *shaderFName;//片段着色器名

//加载纹理
- (void)loadTexture:(GlVideoFrameModel *)frameModel;

//渲染时绑定纹理
- (void)bindTexture:(CommShader *)shader;
@end
