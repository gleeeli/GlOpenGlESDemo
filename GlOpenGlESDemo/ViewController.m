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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *muarray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.muarray = [[NSMutableArray alloc] init];
    [self.muarray addObject:@"draw triangle(三角)"];
    [self.muarray addObject:@"draw Rectangle(四角)"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.muarray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSString *title = self.muarray[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.muarray[indexPath.row];
    UIViewController *vc;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([title isEqualToString:@"draw triangle(三角)"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"OPGlTriangleViewController"];
        //vc = [[OPGlTriangleViewController alloc] init];
        
    }else if ([title isEqualToString:@"draw Rectangle(四角)"]) {
        //vc = [[RectangleViewController alloc] init];
        vc = [storyboard instantiateViewControllerWithIdentifier:@"RectangleViewController"];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
