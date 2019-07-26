//
//  MouseAngleCSViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/19.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "MouseAngleCSViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#include <string>
#include <OpenGLES/ES2/glext.h>

@interface MouseAngleCSViewController ()
@property (nonatomic, assign) float pitch;//俯仰角
@property (nonatomic, assign) float yaw;//偏航角
@end

@implementation MouseAngleCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGesture];
    [self addPicGesture];
}

- (void)addGesture {
    self.pitch = 0.f;
    // yaw is initialized to -90.0 degrees since a yaw of 0.0 results in a direction vector pointing to the right so we initially rotate a bit to the left
    self.yaw = -90.0f;//这里 上面那段英文没明白
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGest];
}

- (void)addPicGesture {
    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    [self.view addGestureRecognizer:pinchGest];
}

//滑动手势
- (void)panGestureAction:(UIPanGestureRecognizer *)panGest {
    
    CGPoint trans = [panGest translationInView:self.view];
    
    NSLog(@"当前滑动:%@",NSStringFromCGPoint(trans));
    
    float xoffset = trans.x;
    float yoffset = trans.y;
    
    float sensitivity = 0.01f;
    xoffset *= sensitivity;
    yoffset *= sensitivity;
    
    self.yaw += xoffset;
    self.pitch += yoffset;
    
    //我们需要给摄像机添加一些限制，这样摄像机就不会发生奇怪的移动了（这样也会避免一些奇怪的问题）。对于俯仰角，要让用户不能看向高于89度的地方（在90度时视角会发生逆转，所以我们把89度作为极限），同样也不允许小于-89度。这样能够保证用户只能看到天空或脚下，但是不能超越这个限制。
    if(self.pitch > 89.0f)
        self.pitch =  89.0f;
    if(self.pitch < -89.0f)
        self.pitch = -89.0f;
    
    NSLog(@"俯仰角：%f,偏转角:%f",self.pitch,self.yaw);
    float x = cos(glm::radians(self.yaw)) * cos(glm::radians(self.pitch));
    float y = sin(glm::radians(self.pitch));
    float z = sin(glm::radians(self.yaw)) * cos(glm::radians(self.pitch));
    NSLog(@"x：%f,y:%f,z:%f",x,y,z);
    [self setCameraFrontX:x y:y z:z];
}

//缩放手势
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinch {
    //pinch.scale范围大概0-10
    NSLog(@"缩放：%f",pinch.scale);
    if (pinch.scale <1) {
        self.fov += pinch.scale;
    }else {
        self.fov -= pinch.scale;
    }
    
    
}

/*
欧拉角(Euler Angle)是可以表示3D空间中任何旋转的3个值，由莱昂哈德·欧拉(Leonhard Euler)在18世纪提出。一共有3种欧拉角：俯仰角(Pitch)、偏航角(Yaw)和滚转角(Roll)，
 偏航角，偏航角表示我们往左和往右看的程度。滚转角代表我们如何翻滚摄像机
 https://learnopengl-cn.github.io/01%20Getting%20started/09%20Camera/
*/

@end
