//
//  ControlMoveCSViewController.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/19.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "MultiplerCubeViewController.h"

@interface ControlMoveCSViewController : MultiplerCubeViewController

//个缩放(Zoom)接口。在之前的教程中我们说视野(Field of View)或fov定义了我们可以看到场景中多大的范围。当视野变小时，场景投影出来的空间就会减小，产生放大(Zoom In)了的感觉。
@property (nonatomic, assign) float fov;


- (void)setCameraFrontX:(float)x y:(float)y z:(float)z;
@end
