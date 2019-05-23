//
//  LightColorsMaterialViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/23.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "LightColorsMaterialViewController.h"
#import "CommShader.h"

@interface LightColorsMaterialViewController ()

@end

@implementation LightColorsMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initShaderName {
    self.lightFrageShaderName = @"LightColors_material_shaderf";
}

- (void)moveLambPosition {
    //函数体为空 则不移动光源
}

- (void)setOtherLightShader {
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
    
    [self.lightShader setVec3:"material.ambient" x:1.0f y:0.5f z:0.31f];
    [self.lightShader setVec3:"material.diffuse" x:1.0f y:0.5f z:0.31f];
    [self.lightShader setVec3:"material.specular" x:0.5f y:0.5f z:0.5f];
    [self.lightShader setFload:"material.shininess" floatv:32.0f];
}


/*
ambient ：周围的 环境光
 diffuse：漫反射
 specular：镜面反射
*/

@end
