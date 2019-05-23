//
//  CommCamera.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <glm/glm.hpp>

typedef enum : NSUInteger {
    Camera_forward,
    Camera_backward,
    Camera_left,
    Camera_right,
} Camera_Movement;
@interface CommCamera : NSObject
@property (nonatomic, assign) float yaw;
@property (nonatomic, assign) float pitch;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float sensitivity;
@property (nonatomic, assign) float zoom;

- (instancetype)initWithBackView:(UIView *)view;
- (NSTimeInterval)getTimeRuning;

//带有C++类型的方法声明
#ifdef __cplusplus
- (instancetype)initWithBackView:(UIView *)view cameraPos:(glm::vec3)cameraPos;
- (instancetype)initWithBackView:(UIView *)view cameraPos:(glm::vec3)cameraPos cameraUp:(glm::vec3)cameraUp yaw:(float)yaw pitch:(float)pitch;
- (glm::mat4)GetViewMatrix;
- (glm::vec3)getCameraPosition;
#endif

/*
 每次绘制调用该方法
为了解决 实际情况下根据处理器的能力不同，有些人可能会比其他人每秒绘制更多帧，也就是以更高的频率调用moveBtnClick函数。结果就是，根据配置的不同，有些人可能移动很快，而有些人会移动很慢。（自己理解：也就是用户点击向右，相当于从a点到b点。这时开始绘制渲染，有些cpu绘制这个位移是1s，有些cpu则是2s。想同的距离不同的时间绘制完成，造成速度不一样。）*/
- (void)handleDelay;
@end
