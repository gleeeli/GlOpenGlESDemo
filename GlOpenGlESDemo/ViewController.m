//
//  ViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2018/9/11.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "ViewController.h"
#import "OPGlTriangleViewController.h"
#import "RectangleViewController.h"
#import "GLSLViewController.h"
#import "GlSLUniformViewController.h"
#import "GLSLColorVertexViewController.h"
#import "TextureViewController.h"
#import "TwoTextureViewController.h"
#import "TransformViewController.h"
#import "CoordinateSystemsViewController.h"
#import "CubeCSViewController.h"
#import "MultiplerCubeViewController.h"
#import "CameraCSViewController.h"
#import "ControlMoveCSViewController.h"
#import "MouseAngleCSViewController.h"
#import "LightColorsViewController.h"
#import "LightColorsMaterialViewController.h"
#import "DiffuseMapViewController.h"
#import "DepthTestViewController.h"
#import "StencilTestViewController.h"
#import "FrameBufferViewController.h"
#import "FrameBufferSimpleExampleViewController.h"
#import "VideoDemoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *muarray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OpenGL";
    self.muarray = [[NSMutableArray alloc] init];
    [self.muarray addObject:@{@"name":@"draw triangle",@"desc":@"画三角形"}];
    [self.muarray addObject:@{@"name":@"draw Rectangle",@"desc":@"画矩形，索引缓冲对象 确定顶点绘制顺序"}];
    [self.muarray addObject:@{@"name":@"GLSL",@"desc":@"着色器间属性传递"}];
    [self.muarray addObject:@{@"name":@"GLSL Uniform",@"desc":@"着色器全局变量,实现颜色渐变"}];
    [self.muarray addObject:@{@"name":@"GLSL vertexColor",@"desc":@"设置每个顶点颜色"}];
    [self.muarray addObject:@{@"name":@"Texture",@"desc":@"纹理,生成图片，生成图片与顶点颜色的混合色"}];
    [self.muarray addObject:@{@"name":@"Texture Two",@"desc":@"双重纹理"}];
    [self.muarray addObject:@{@"name":@"Transform",@"desc":@"变换，矩阵的加减乘等算法。可实现一些位移，缩放，旋转"}];
    [self.muarray addObject:@{@"name":@"3D Coordinate",@"desc":@"坐标系统 3D坐标转2D坐标"}];
    [self.muarray addObject:@{@"name":@"3D Cube",@"desc":@"坐标系统 3D立方体"}];
    [self.muarray addObject:@{@"name":@"Multiple 3D Cube",@"desc":@"坐标系统 多个3D立方体"}];
    [self.muarray addObject:@{@"name":@"3D Camera System",@"desc":@"坐标系统 摄像头坐标的利用，实现整个场景旋转"}];
    [self.muarray addObject:@{@"name":@"3D Control Move",@"desc":@"坐标系统 手动控制摄像头移动"}];
    [self.muarray addObject:@{@"name":@"3D 欧拉角(Euler Angle)",@"desc":@"坐标系统 手指滑动控制视角或鼠标控制视角"}];
    [self.muarray addObject:@{@"name":@"基础光照 颜色",@"desc":@"光照呈现不同的立体颜色"}];
    [self.muarray addObject:@{@"name":@"基础光照 材质",@"desc":@"光对不同材质物体影响直观表现"}];
    [self.muarray addObject:@{@"name":@"纹理贴图",@"desc":@"光对贴图物体的影响"}];
    [self.muarray addObject:@{@"name":@"深度测试",@"desc":@"深度缓存，防止后绘制的挡在前面，比如地板"}];
    [self.muarray addObject:@{@"name":@"模板测试",@"desc":@"立方体画边框"}];
    [self.muarray addObject:@{@"name":@"帧缓冲",@"desc":@"帧缓冲和深度缓冲的结合，离屏渲染，反向效果"}];
    [self.muarray addObject:@{@"name":@"帧缓冲2",@"desc":@"简单案列"}];
    [self.muarray addObject:@{@"name":@"视频播放帧显示",@"desc":@"YUV和RGB结合帧缓冲显示"}];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableview.estimatedRowHeight = 44;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.muarray count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 88;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = [self getDictWithRow:indexPath];
    NSString *title = dict[@"name"];
    NSString *desc = dict[@"desc"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd.%@：%@",([self.muarray count] - indexPath.row),title,desc];
    cell.textLabel.numberOfLines = 0;
    return cell;
}
    
/**
 倒序
 */
- (NSDictionary *)getDictWithRow:(NSIndexPath *)indexPath {
    NSInteger row = [self.muarray count] - indexPath.row - 1;
    NSDictionary *dict = self.muarray[row];
    return dict;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self getDictWithRow:indexPath];
    NSString *title = dict[@"name"];
    NSString *desc = dict[@"desc"];
    UIViewController *vc;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([title isEqualToString:@"draw triangle"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"OPGlTriangleViewController"];
        
    }else if ([title isEqualToString:@"draw Rectangle"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"RectangleViewController"];
    }else if ([title isEqualToString:@"GLSL"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"GLSLViewController"];
    }else if ([title isEqualToString:@"GLSL Uniform"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"GlSLUniformViewController"];
    }else if ([title isEqualToString:@"GLSL vertexColor"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"GLSLColorVertexViewController"];
    }
    else if ([title isEqualToString:@"Texture"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"TextureViewController"];
    }else if ([title isEqualToString:@"Texture Two"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"TwoTextureViewController"];
    }
    else if ([title isEqualToString:@"Transform"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"TransformViewController"];
    }
    else if ([title isEqualToString:@"3D Coordinate"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"CoordinateSystemsViewController"];
    }
    else if ([title isEqualToString:@"3D Cube"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"CubeCSViewController"];
    }
    else if ([title isEqualToString:@"Multiple 3D Cube"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"MultiplerCubeViewController"];
    }else if ([title isEqualToString:@"3D Camera System"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"CameraCSViewController"];
    }else if ([title isEqualToString:@"3D Control Move"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"ControlMoveCSViewController"];
    }else if ([title isEqualToString:@"3D 欧拉角(Euler Angle)"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"MouseAngleCSViewController"];
    }else if ([title isEqualToString:@"基础光照 颜色"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"LightColorsViewController"];
    }else if ([title isEqualToString:@"基础光照 材质"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"LightColorsMaterialViewController"];
    }else if ([title isEqualToString:@"纹理贴图"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"DiffuseMapViewController"];
    }else if ([title isEqualToString:@"深度测试"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"DepthTestViewController"];
    }else if ([title isEqualToString:@"模板测试"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"StencilTestViewController"];
    }else if ([title isEqualToString:@"帧缓冲"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"FrameBufferViewController"];
    }else if ([title isEqualToString:@"帧缓冲2"]) {
        vc = [[FrameBufferSimpleExampleViewController alloc] init];
    }else if ([title isEqualToString:@"视频播放帧显示"]) {
        vc = [[VideoDemoViewController alloc] init];
    }

    vc.title = desc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
