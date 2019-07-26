//
//  FrameBufferView.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/7/5.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <OpenGLES/ES3/gl.h>
//#import <OpenGLES/ES3/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface FrameBufferView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    GLuint _frameBuffer1;
    GLuint _depthRenderBuffer;
}
@end
