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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *muarray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.muarray = [[NSMutableArray alloc] init];
    [self.muarray addObject:@{@"name":@"draw triangle",@"desc":@"画三角形"}];
    [self.muarray addObject:@{@"name":@"draw Rectangle",@"desc":@"画矩形，索引缓冲对象 确定顶点绘制顺序"}];
    [self.muarray addObject:@{@"name":@"GLSL",@"desc":@"着色器间属性传递"}];
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",title,desc];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.muarray[indexPath.row];
    NSString *title = dict[@"name"];
    UIViewController *vc;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([title isEqualToString:@"draw triangle"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"OPGlTriangleViewController"];
        
    }else if ([title isEqualToString:@"draw Rectangle"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"RectangleViewController"];
    }else if ([title isEqualToString:@"GLSL"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"GLSLViewController"];
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
