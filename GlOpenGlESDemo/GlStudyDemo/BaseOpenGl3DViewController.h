//
//  BaseOpenGl3DViewController.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseOpenGl3DViewController : GLKViewController
@property (nonatomic , strong) EAGLContext* mContext;

- (void)setupOpenGlBase;
@end

NS_ASSUME_NONNULL_END
