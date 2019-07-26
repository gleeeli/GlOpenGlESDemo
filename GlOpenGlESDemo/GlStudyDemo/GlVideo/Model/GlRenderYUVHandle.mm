//
//  GlRenderYUVHandle.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/7/10.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "GlRenderYUVHandle.h"

@implementation GlRenderYUVHandle
{
    GLuint textureIds[3];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shaderVName = @"gl_video_shaderv";
        self.shaderFName = @"gl_video_yuv_shaderf";
    }
    
    return self;
}

- (void)loadTexture:(GlVideoFrameModel *)frameModel {
    NSLog(@"加载YUV纹理");
    if (0 == textureIds[0]){
        glGenTextures(3, textureIds);
    }
    
    GlVideoFrameYUVModel *yuvFrameModel = (GlVideoFrameYUVModel *)frameModel;
    GLsizei fwidth = (GLsizei)yuvFrameModel.width;
    GLsizei fheight = (GLsizei)yuvFrameModel.height;
    
    const GLvoid *pixels[3] = {yuvFrameModel.lumaY.bytes,yuvFrameModel.chrominanceU.bytes, yuvFrameModel.chromaV.bytes };
    //U和V的宽高都只有Y的一半
    const GLsizei widths[3]  = { fwidth, fwidth / 2, fwidth / 2 };
    const GLsizei heights[3] = { fheight, fheight / 2, fheight / 2 };
    
    for (int i = 0; i < 3; ++i) {
        
        glBindTexture(GL_TEXTURE_2D, textureIds[i]);
        
        glTexImage2D(GL_TEXTURE_2D,
                     0,
                     GL_LUMINANCE,
                     widths[i],
                     heights[i],
                     0,
                     GL_LUMINANCE,
                     GL_UNSIGNED_BYTE,
                     pixels[i]);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
}

- (void)bindTexture:(CommShader *)shader {
    NSLog(@"绑定YUV纹理");
    std::string name[3] = {"LumaY","ChrominanceU","ChromaV"};
    for (int i = 0; i < 3; ++i) {
        //YUV需要三个纹理单元才能存下
        glActiveTexture(GL_TEXTURE0 + i);
        //将纹理附件绑定到默认的0号纹理单元
        glBindTexture(GL_TEXTURE_2D, textureIds[i]);    // use the color attachment texture as the texture of the quad plane
        
        [shader setInt:name[i] intv:i];
    }
    
}
@end
