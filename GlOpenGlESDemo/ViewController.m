//
//  ViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2018/9/11.
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
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableview.estimatedRowHeight = 44;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.muarray count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 88;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.muarray[indexPath.row];
    NSString *title = dict[@"name"];
    NSString *desc = dict[@"desc"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd.%@：%@",(indexPath.row + 1),title,desc];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.muarray[indexPath.row];
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

    vc.title = desc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
