//
//  FrameBufferSimpleExampleViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/7/5.
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
