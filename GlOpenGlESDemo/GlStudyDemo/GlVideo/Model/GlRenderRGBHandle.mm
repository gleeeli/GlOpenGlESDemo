//
//  GlRenderRGBHandle.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/7/10.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "GlRenderRGBHandle.h"
#import "GlVideoFrameRGBModel.h"

@implementation GlRenderRGBHandle
{
    GLuint textureId;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shaderVName = @"gl_video_shaderv";
        self.shaderFName = @"gl_video_rgb_shaderf";
    }
    
    return self;
}

- (void)loadTexture:(GlVideoFrameModel *)frameModel {
    NSLog(@"加载RGB纹理");
    GlVideoFrameRGBModel *rgbFrameModel = (GlVideoFrameRGBModel *)frameModel;
    GLsizei fwidth = (GLsizei)rgbFrameModel.width;
    GLsizei fheight = (GLsizei)rgbFrameModel.height;
    
    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_LUMINANCE,
                 fwidth,
                 fheight,
                 0,
                 GL_LUMINANCE,
                 GL_UNSIGNED_BYTE,
                 rgbFrameModel.rgbData.bytes);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)bindTexture:(CommShader *)shader {
    NSLog(@"绑定RGB纹理");
    glActiveTexture(GL_TEXTURE0);
    //将纹理附件绑定到默认的0号纹理单元
    glBindTexture(GL_TEXTURE_2D, textureId);    // use the color attachment texture as the texture of the quad plane
    
    [shader setInt:"rgbTexture" intv:0];
}
@end
