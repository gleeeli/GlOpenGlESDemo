//
//  FrameBufferSimpleExampleViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/7/5.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "FrameBufferSimpleExampleViewController.h"
#import "FrameBufferView.h"
#import "CommHeader.h"

@interface FrameBufferSimpleExampleViewController ()
@property (nonatomic, strong) FrameBufferView *fView;
@end

@implementation FrameBufferSimpleExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _fView = [[FrameBufferView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-10)];
    [self.view addSubview:_fView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

/*
 一个完整的帧缓冲需要满足以下的条件：
 
 附加至少一个缓冲（颜色、深度或模板缓冲）。
 至少有一个颜色附件(Attachment)。
 所有的附件都必须是完整的（保留了内存）。
 每个缓冲都应该有相同的样本数。
 
 调用glCheckFramebufferStatus，检查帧缓冲是否完整。它将会检测当前绑定的帧缓冲，并返回规范中这些值的其中之一。如果它返回的是GL_FRAMEBUFFER_COMPLETE，帧缓冲就是完整的了
*/

@end
