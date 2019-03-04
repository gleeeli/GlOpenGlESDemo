//
//  TextureViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "TextureViewController.h"

@interface TextureViewController ()

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
 第一个参数指定了纹理目标；我们使用的是2D纹理，因此纹理目标是GL_TEXTURE_2D。
 第二个参数需要我们指定设置的选项与应用的纹理轴
 第三个参数传递一个环绕方式
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
 
 GL_REPEAT    对纹理的默认行为。重复纹理图像。
 GL_MIRRORED_REPEAT    和GL_REPEAT一样，但每次重复图片是镜像放置的。
 GL_CLAMP_TO_EDGE    纹理坐标会被约束在0到1之间，超出的部分会重复纹理坐标的边缘，产生一种边缘被拉伸的效果。
 GL_CLAMP_TO_BORDER    超出的坐标为用户指定的边缘颜色。
 
 （GL_CLAMP_TO_BORDER 此方式多传一个参数：
 float borderColor[] = { 1.0f, 1.0f, 0.0f, 1.0f };
 glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);）
 
 
 纹理过滤：
 
 */
@end
