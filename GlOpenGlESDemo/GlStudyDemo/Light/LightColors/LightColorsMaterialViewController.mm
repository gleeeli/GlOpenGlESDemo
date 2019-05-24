//
//  LightColorsMaterialViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/23.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "LightColorsMaterialViewController.h"
#import "CommShader.h"

typedef enum : NSUInteger {
    MaterialTypeChanged = 0,
    MaterialTypeCyanPlastic,//青色塑料
} MaterialType;
@interface LightColorsMaterialViewController ()
@property (nonatomic, strong) UIButton *changBtn;
@property (nonatomic, assign) MaterialType type;
@end

@implementation LightColorsMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 150, 50)];
    self.changBtn = btn;
    [btn setTitle:@"切换物质" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;
    [self.view addSubview:btn];
}

- (void)initShaderName {
    [super initShaderName];
    self.lightFrageShaderName = @"LightColors_material_shaderf";
}

- (void)moveLambPosition {
    //函数体为空 则不移动光源
}

- (void)setOtherLightShader {
    if (self.type == MaterialTypeCyanPlastic) {
        [self setCyanPlastic];
    }else {
        [self setRunLightColor];
    }
}

- (void)changTypeBtnClick:(UIButton *)btn {
    self.type = self.type ==MaterialTypeChanged ? MaterialTypeCyanPlastic:MaterialTypeChanged;
    if (self.type == MaterialTypeCyanPlastic) {
        [self.changBtn setTitle:@"青色塑料" forState:UIControlStateNormal];
    }else {
        [self.changBtn setTitle:@"不同光源颜色" forState:UIControlStateNormal];
    }
}

- (void)setRunLightColor {
    NSArray *array = [self getLightPos];
    float lx = [array[0] floatValue];
    float ly = [array[1] floatValue];
    float lz = [array[2] floatValue];
    glm::vec3 lightPos(lx, ly, lz);
    
    [self.lightShader setVec3:"light.position" vec3:lightPos];
    
    glm::vec3 lightColor;
    lightColor.x = sin([self getRunTime] * 2.0f);
    lightColor.y = sin([self getRunTime] * 0.7f);
    lightColor.z = sin([self getRunTime] * 1.3f);
    
    glm::vec3 diffuseColor = lightColor   * glm::vec3(0.5f); // 降低影响
    glm::vec3 ambientColor = diffuseColor * glm::vec3(0.5f); // 很低的影响
    
    [self.lightShader setVec3:"light.ambient" vec3:ambientColor];
    [self.lightShader setVec3:"light.diffuse" vec3:diffuseColor];
    [self.lightShader setVec3:"light.specular" x:1.0f y:1.0f z:1.0f];
    
    [self.lightShader setVec3:"material.ambient" x:1.0f y:0.5f z:0.31f];
    [self.lightShader setVec3:"material.diffuse" x:1.0f y:0.5f z:0.31f];
    [self.lightShader setVec3:"material.specular" x:0.5f y:0.5f z:0.5f];
    [self.lightShader setFload:"material.shininess" floatv:32.0f];
}

- (void)setCyanPlastic {
    NSArray *array = [self getLightPos];
    float lx = [array[0] floatValue];
    float ly = [array[1] floatValue];
    float lz = [array[2] floatValue];
    glm::vec3 lightPos(lx, ly, lz);
    
    [self.lightShader setVec3:"light.position" vec3:lightPos];
    
//    glm::vec3 lightColor;
//    lightColor.x = sin([self getRunTime] * 2.0f);
//    lightColor.y = sin([self getRunTime] * 0.7f);
//    lightColor.z = sin([self getRunTime] * 1.3f);
//
//    glm::vec3 diffuseColor = lightColor   * glm::vec3(0.5f); // 降低影响
//    glm::vec3 ambientColor = diffuseColor * glm::vec3(0.5f); // 很低的影响
    
    [self.lightShader setVec3:"light.ambient" x:1.0f y:1.0f z:1.0f];
    [self.lightShader setVec3:"light.diffuse" x:1.0f y:1.0f z:1.0f];
    [self.lightShader setVec3:"light.specular" x:1.0f y:1.0f z:1.0f];
    
    [self.lightShader setVec3:"material.ambient" x:0.0f y:0.1f z:0.06f];
    [self.lightShader setVec3:"material.diffuse" x:0.0f y:0.50980392f z:0.50980392f];
    [self.lightShader setVec3:"material.specular" x:0.50196078f y:0.50196078f z:0.50196078f];
    [self.lightShader setFload:"material.shininess" floatv:32.0f];
}


/*
ambient ：周围的 环境光
 diffuse：漫反射
 specular：镜面反射
*/

@end
