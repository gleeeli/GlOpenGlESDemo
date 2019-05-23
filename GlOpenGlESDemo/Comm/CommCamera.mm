//
//  CommCamera.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "CommCamera.h"
#import <UIKit/UIKit.h>
#import "CommHeader.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

@interface CommCamera()
@property (nonatomic, strong) UIView  *view;
@property (nonatomic, assign) NSTimeInterval deltaFrame;
@property (nonatomic, assign) NSTimeInterval lastFrame;
@property (nonatomic, assign) NSTimeInterval startTime;
@end

@implementation CommCamera
{
    glm::vec3 cameraPosition;
    glm::vec3 cameraFront;
    glm::vec3 cameraUp;
    glm::vec3 cameraRight;
    glm::vec3 cameraWordUp;
}
- (instancetype)initWithBackView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
        [self initBase];
        [self updateCameraVectors];
    }
    
    return self;
}

- (instancetype)initWithBackView:(UIView *)view cameraPos:(glm::vec3)cameraPos
{
    self = [super init];
    if (self) {
        self.view = view;
        [self initBase];
        cameraPosition = cameraPos;
        [self updateCameraVectors];
    }
    
    return self;
}


- (instancetype)initWithBackView:(UIView *)view cameraPos:(glm::vec3)cameraPos cameraUp:(glm::vec3)cameraUp yaw:(float)yaw pitch:(float)pitch
{
    self = [super init];
    if (self) {
        self.view = view;
        [self initBase];
        cameraPosition = cameraPos;
        cameraWordUp = cameraUp;
        self.yaw = yaw;
        self.pitch = pitch;
        [self updateCameraVectors];
    }
    
    return self;
}

-(void)initBase {
    //3.f 代表z轴 越大，摄像头后退，物体离屏幕越远
    cameraPosition   = glm::vec3(0.0f, 0.0f,  3.0f);
    cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
    cameraUp    = glm::vec3(0.0f, 1.0f,  0.0f);
    cameraWordUp = cameraUp;
    
    self.yaw = -90.0;////偏航角
    self.pitch = 0.f;////俯仰角
    self.speed = 2.5f;
    self.sensitivity = 0.1f;
    self.zoom = 45.0f;
    
    self.lastFrame = 0;
    self.deltaFrame = 0;
    self.startTime = 0;
    
    [self createMoveView];
    
    [self addGesture];
    [self addPicGesture];
}

- (glm::mat4)GetViewMatrix {
    //此处LookAt函数需要一个位置、目标和上向量。它会创建一个观察矩阵。将世界坐标变换到以摄像机为原点的坐标系统
    /*cameraPos：摄像机位置
     第二个参数：方向是当前的位置加上我们刚刚定义的方向向量。这样能保证无论我们怎么移动，摄像机都会注视着目标方向
     */
    return glm::lookAt(cameraPosition, cameraPosition + cameraFront, cameraUp);
}

- (void)updateCameraVectors {
    // Calculate the new Front vector
    glm::vec3 front;
    front.x = cos(glm::radians(self.yaw)) * cos(glm::radians(self.pitch));
    front.y = sin(glm::radians(self.pitch));
    front.z = sin(glm::radians(self.yaw)) * cos(glm::radians(self.pitch));
    cameraFront = glm::normalize(front);
    // Also re-calculate the Right and Up vector
    cameraRight = glm::normalize(glm::cross(cameraFront, cameraWordUp));  // Normalize the vectors, because their length gets closer to 0 the more you look up or down which results in slower movement.
    cameraUp    = glm::normalize(glm::cross(cameraRight, cameraFront));
}

- (void)createMoveView {
    CGFloat maxWith = 60;
    CGFloat minWidth = 30;
    CGFloat centerWH = 50;//中心空隙的宽高
    CGFloat halfCWH = centerWH * 0.5;
    
    //中心点的坐标
    CGPoint center = CGPointMake(10 + maxWith + halfCWH, SCREEN_HEIGHT - maxWith - 10 - halfCWH);
    
    NSArray *array = @[@"向前",@"向左",@"向后",@"向右"];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    for (int i = 0; i < [array count]; i++) {
        
        if (i == 0) {
            width = minWidth;
            height = maxWith;
            x = center.x - minWidth * 0.5;
            y = center.y - maxWith - halfCWH;
        }else if(i == 2){
            width = minWidth;
            height = maxWith;
            x = center.x - minWidth * 0.5;
            y = center.y + halfCWH;
        }else if(i == 1){
            width = maxWith;
            height = minWidth;
            x = center.x - maxWith - halfCWH;
            y = center.y -  halfCWH;
        }else if(i == 3){
            width = maxWith;
            height = minWidth;
            x = center.x + halfCWH;
            y = center.y -  halfCWH;
        }
        
        UIButton *tMovebtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        tMovebtn.tag = 100 + i;
        [tMovebtn setTitle:array[i] forState:UIControlStateNormal];
        [tMovebtn addTarget:self action:@selector(moveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tMovebtn.backgroundColor = [UIColor greenColor];
        tMovebtn.titleLabel.numberOfLines = 0;
        [self.view addSubview:tMovebtn];
    }
}


- (void)moveBtnClick:(UIButton *)btn {
    NSInteger index = btn.tag - 100;
    //float cameraSpeed = 0.05f;不同设备的cpu会有误差
    float cameraSpeed = self.speed * self.deltaFrame;
    
    switch (index) {
        case 0://向前
        {
            cameraPosition += cameraSpeed * cameraFront;
        }
            break;
        case 1://向左
        {
            //我们使用叉乘来创建一个右向量(Right Vector)，并沿着它相应移动就可以了
            //此处cameraFront为z向量，cameraUp为y向量，相乘可得垂直它俩的x向量
            cameraPosition -= glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
        }
            break;
        case 2://向后
        {
            cameraPosition -= cameraSpeed * cameraFront;
        }
            break;
        case 3://向右
        {
            cameraPosition += glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
        }
            break;
            
        default:
            break;
    }
}

/*
 每次绘制调用该方法
 为了解决 实际情况下根据处理器的能力不同，有些人可能会比其他人每秒绘制更多帧，也就是以更高的频率调用moveBtnClick函数。结果就是，根据配置的不同，有些人可能移动很快，而有些人会移动很慢。（自己理解：也就是用户点击向右，相当于从a点到b点。这时开始绘制渲染，有些cpu绘制这个位移是1s，有些cpu则是2s。想同的距离不同的时间绘制完成，造成速度不一样。）*/
- (void)handleDelay {
    if (self.startTime == 0) {
        self.startTime = [[NSDate date]timeIntervalSince1970];
    }
    NSTimeInterval interval = [self getTimeRuning];
    
    self.deltaFrame = interval - self.lastFrame;
    self.lastFrame = interval;
}

/**
 获取运行时间
 */
- (NSTimeInterval)getTimeRuning {
    return [[NSDate date]timeIntervalSince1970] - self.startTime;
}

#pragma mark 手势

- (void)addGesture {
    self.pitch = 0.f;
    // yaw is initialized to -90.0 degrees since a yaw of 0.0 results in a direction vector pointing to the right so we initially rotate a bit to the left
    self.yaw = -90.0f;//这里 上面那段英文没明白
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGest];
}

/**
 缩放
 */
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
    //改变摄像头的朝向角度
    [self setCameraFrontX:x y:y z:z];
}

//缩放手势
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinch {
    //pinch.scale范围大概0-10
    NSLog(@"缩放：%f",pinch.scale);
    if (pinch.scale <1) {
        self.zoom += pinch.scale;
    }else {
        self.zoom -= pinch.scale;
    }
    
    
}

/**
 设置摄像头的向前向量
 */
- (void)setCameraFrontX:(float)x y:(float)y z:(float)z {
    
    glm::vec3 front;
    front.x = x;
    front.y = y;
    front.z = -1;
    cameraFront = glm::normalize(front);
}

- (glm::vec3)getCameraPosition {
    return cameraPosition;
}
@end
