//
//  ControlMoveCSViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/19.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "ControlMoveCSViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#include <string>
#include <OpenGLES/ES2/glext.h>

glm::vec3 cameraPos   = glm::vec3(0.0f, 0.0f,  3.0f);
glm::vec3 cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
glm::vec3 cameraUp    = glm::vec3(0.0f, 1.0f,  0.0f);

@interface ControlMoveCSViewController ()
@property (nonatomic, assign) BOOL isFirst;

//为了解决 实际情况下根据处理器的能力不同，有些人可能会比其他人每秒绘制更多帧，也就是以更高的频率调用moveBtnClick函数。结果就是，根据配置的不同，有些人可能移动很快，而有些人会移动很慢。（自己理解：也就是用户点击向右，相当于从a点到b点。这时开始绘制渲染，有些cpu绘制这个位移是1s，有些cpu则是2s。想同的距离不同的时间绘制完成，造成速度不一样。）
@property (nonatomic, assign) NSTimeInterval deltaFrame;
@property (nonatomic, assign) NSTimeInterval lastFrame;
@end

@implementation ControlMoveCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    self.lastFrame = 0;
    self.deltaFrame = 0;
    self.fov = 45.0f;//初始视宽，越大能看到的东西就越多。（就像人拿望眼镜看到的东西大，但是不多，去掉望远镜看到的东西多）
    
    [self createHandShank];
}

- (void)createHandShank {
    
    if (!self.isFirst) {
        return;
    }
    self.isFirst = YES;
    
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
    float cameraSpeed = 2.5f * self.deltaFrame;
    
    switch (index) {
        case 0://向前
        {
            cameraPos += cameraSpeed * cameraFront;
        }
            break;
        case 1://向左
        {
            //我们使用叉乘来创建一个右向量(Right Vector)，并沿着它相应移动就可以了
            //此处cameraFront为z向量，cameraUp为y向量，相乘可得垂直它俩的x向量
            cameraPos -= glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
        }
            break;
        case 2://向后
        {
            cameraPos -= cameraSpeed * cameraFront;
        }
            break;
        case 3://向右
        {
            cameraPos += glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
        }
            break;
            
        default:
            break;
    }
}

- (void)handle3D {
    
    NSTimeInterval interval = [self getTimeRuning];
    
    self.deltaFrame = interval - self.lastFrame;
    self.lastFrame = interval;
    
    //    interval = 1;
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    
    //此处LookAt函数需要一个位置、目标和上向量。它会创建一个观察矩阵。将世界坐标变换到以摄像机为原点的坐标系统
    /*cameraPos：摄像机位置
     第二个参数：方向是当前的位置加上我们刚刚定义的方向向量。这样能保证无论我们怎么移动，摄像机都会注视着目标方向
     */
    view = glm::lookAt(cameraPos, cameraPos + cameraFront, cameraUp);
    
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(self.fov), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    
    //绑定到shader GLSL
    unsigned int viewLoc  = glGetUniformLocation(shaderProgram, "view");
    // pass them to the shaders (3 different ways)
    glUniformMatrix4fv(viewLoc, 1, GL_FALSE, &view[0][0]);
    [self setMat4:"projection" mat4:projection];
}

- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4 {
    glUniformMatrix4fv(glGetUniformLocation(shaderProgram, name.c_str()), 1, GL_FALSE, &mat4[0][0]);
}

- (void)setCameraFrontX:(float)x y:(float)y z:(float)z {
    
    glm::vec3 front;
    front.x = x;
    front.y = y;
    front.z = -1;
    cameraFront = glm::normalize(front);
}
@end
