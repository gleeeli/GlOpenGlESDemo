//
//  MultiplerCubeViewController.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/4/18.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "MultiplerCubeViewController.h"
#import <OpenGLES/ES2/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#import "CommHeader.h"
#include <string>
#include <OpenGLES/ES2/glext.h>

//申明位移向量
static glm::vec3 cubePositions[] = {
    glm::vec3( 0.0f,  0.0f,  0.0f),
    glm::vec3( 2.0f,  5.0f, -15.0f),
    glm::vec3(-1.5f, -2.2f, -6.5f),//左下
    glm::vec3(-0.1f, -2.0f, -10.3f),//中下
    glm::vec3( 1.2f, -1.4f, -3.5f),//右下
    glm::vec3(-1.7f,  3.0f, -7.5f),
    glm::vec3( 0.3f, -2.0f, -2.5f),//下中
    glm::vec3( 1.5f,  2.0f, -2.5f),
    glm::vec3( 1.5f,  0.2f, -1.5f),
    glm::vec3(-1.3f,  1.0f, -1.5f)
};

@interface MultiplerCubeViewController ()

@end

@implementation MultiplerCubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)handle3D {
    NSTimeInterval interval = [self getTimeRuning];
    //    interval = 1;
    glm::mat4 view          = glm::mat4(1.0f);
    glm::mat4 projection    = glm::mat4(1.0f);
    // 注意，我们将矩阵向我们要进行移动场景的反方向移动。这里向z轴移动，负数代表远离屏幕的效果
    view  = glm::translate(view, glm::vec3(0.0f, 0.0f, -4.0f));
    //声明一个投影矩阵：
    projection = glm::perspective(glm::radians(45.0f), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
    unsigned int viewLoc  = glGetUniformLocation(shaderProgram, "view");
    // pass them to the shaders (3 different ways)
    glUniformMatrix4fv(viewLoc, 1, GL_FALSE, &view[0][0]);
    [self setMat4:"projection" mat4:projection];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    //深度测试清除缓存
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // bind Texture
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.myTexture);
    
    [self useProgram];
    [self handle3D];
    glBindVertexArrayOES(VAO);
    
    for(unsigned int i = 0; i < 10; i++)
    {
        glm::mat4 model = glm::mat4(1.0f);
        //使用位移向量从初始位置移动到不同空间位置
        model = glm::translate(model, cubePositions[i]);
        float angle = 20.0f * i + 45;
        model = glm::rotate(model, glm::radians(angle), glm::vec3(1.0f, 0.7f, 0.5f));
        [self setMat4:"model" mat4:model];
        
        glDrawArrays(GL_TRIANGLES, 0, 36);
    }
}

- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4 {
    glUniformMatrix4fv(glGetUniformLocation(shaderProgram, name.c_str()), 1, GL_FALSE, &mat4[0][0]);
}

@end
