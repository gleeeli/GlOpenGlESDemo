//
//  CommVertices.c
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/20.
//  Copyright © 2019 gleeeli. All rights reserved.
//
#include <stdio.h> 
#include "CommVertices.h"

//获取立方体 总长度108
float* getCubeVertices(void) {
    //一共需要36个顶点（6个面 x 每个面有2个三角形组成 x 每个三角形有3个顶点）
    static float vertices[] = {
                // z轴上的两个平行面
                //前平面
                0.5f,  0.5f, 0.0f,    // top right
                0.5f, -0.5f, 0.0f,   // bottom right
                -0.5f, -0.5f, 0.0f,   // bottom left
                -0.5f, -0.5f, 0.0f,   // bottom left
                -0.5f,  0.5f, 0.0f,    // top left
                0.5f,  0.5f, 0.0f,    // top right

                //后平面
                0.5f,  0.5f, -0.5f,    // top right
                0.5f, -0.5f, -0.5f,    // bottom right
                -0.5f, -0.5f, -0.5f,  // bottom left
                -0.5f, -0.5f, -0.5f,   // bottom left
                -0.5f,  0.5f, -0.5f,    // top left
                0.5f,  0.5f, -0.5f,   // top right

                // x轴上的两个平行面
                //右平面
                0.5f,  0.5f, -0.5f,   // top right
                0.5f, -0.5f, -0.5f,   // bottom right
                0.5f, -0.5f, 0.0f,  // bottom left
                0.5f, -0.5f, 0.0f,   // bottom left
                0.5f,  0.5f, 0.0f,   // top left
                0.5f,  0.5f, -0.5f,  // top right

                //左平面 留个缺口，不留缺口可将y轴的0.0f改为-0.5f
                -0.5f,  0.5f, -0.5f,  // top right
                -0.5f, 0.0f, -0.5f,   // bottom right
                -0.5f, 0.0f, 0.0f,  // bottom left
                -0.5f, 0.0f, 0.0f,  // bottom left
                -0.5f,  0.5f, 0.0f,   // top left
                -0.5f,  0.5f, -0.5f,   // top right

                // y轴上的两个平行面
                //上平面
                0.5f,  0.5f, -0.5f,  // top right
                0.5f, 0.5f, 0.0f,  // bottom right
                -0.5f, 0.5f, 0.0f,  // bottom left
                -0.5f, 0.5f, 0.0f,  // bottom left
                -0.5f,  0.5f, -0.5f,   // top left
                0.5f,  0.5f, -0.5f,  // top right

                //下平面
                0.5f,  -0.5f, -0.5f,  // top right
                0.5f, -0.5f, 0.0f,    // bottom right
                -0.5f, -0.5f, 0.0f,   // bottom left
                -0.5f, -0.5f, 0.0f,   // bottom left
                -0.5f,  -0.5f, -0.5f,   // top left
                0.5f,  -0.5f, -0.5f, // top right
            };

    return vertices;
}

//获取立方体和每个面的法向量 长度216
float* getCubeAndNoramlVertices(void) {
    //一共需要36个顶点（6个面 x 每个面有2个三角形组成 x 每个三角形有3个顶点）
    static float vertices[] = {
        // z轴上的两个平行面
        //前平面
        0.5f,  0.5f, 0.0f,   0.0f,  0.0f, 1.0f,  // top right
        0.5f, -0.5f, 0.0f,   0.0f,  0.0f, 1.0f, // bottom right
        -0.5f, -0.5f, 0.0f,  0.0f,  0.0f, 1.0f, // bottom left
        -0.5f, -0.5f, 0.0f,  0.0f,  0.0f, 1.0f, // bottom left
        -0.5f,  0.5f, 0.0f,  0.0f,  0.0f, 1.0f, // top left
        0.5f,  0.5f, 0.0f,   0.0f,  0.0f, 1.0f,// top right
        
        //后平面
        0.5f,  0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  // top right
        0.5f, -0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  // bottom right
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f, // bottom left
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f, // bottom left
        -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  // top left
        0.5f,  0.5f, -0.5f,   0.0f,  0.0f, -1.0f,// top right
        
        // x轴上的两个平行面
        //右平面
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f, 0.0f, // top right
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f, 0.0f, // bottom right
        0.5f, -0.5f, 0.0f,   1.0f,  0.0f, 0.0f,// bottom left
        0.5f, -0.5f, 0.0f,   1.0f,  0.0f, 0.0f,// bottom left
        0.5f,  0.5f, 0.0f,   1.0f,  0.0f, 0.0f,// top left
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f, 0.0f,// top right
        
        //左平面 留个缺口，不留缺口可将y轴的0.0f改为-0.5f
        -0.5f,  0.5f, -0.5f,  -1.0f,  0.0f, 0.0f,// top right
        -0.5f, 0.0f, -0.5f,   -1.0f,  0.0f, 0.0f,// bottom right
        -0.5f, 0.0f, 0.0f,    -1.0f,  0.0f, 0.0f,// bottom left
        -0.5f, 0.0f, 0.0f,    -1.0f,  0.0f, 0.0f,// bottom left
        -0.5f,  0.5f, 0.0f,   -1.0f,  0.0f, 0.0f,// top left
        -0.5f,  0.5f, -0.5f,  -1.0f,  0.0f, 0.0f,// top right
        
        // y轴上的两个平行面
        //上平面
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f, 0.0f,// top right
        0.5f, 0.5f, 0.0f,    0.0f,  1.0f, 0.0f,// bottom right
        -0.5f, 0.5f, 0.0f,   0.0f,  1.0f, 0.0f,// bottom left
        -0.5f, 0.5f, 0.0f,   0.0f,  1.0f, 0.0f,// bottom left
        -0.5f,  0.5f, -0.5f, 0.0f,  1.0f, 0.0f, // top left
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f, 0.0f,// top right
        
        //下平面
        0.5f,  -0.5f, -0.5f,  0.0f,  -1.0f, 0.0f,// top right
        0.5f, -0.5f, 0.0f,    0.0f,  -1.0f, 0.0f,// bottom right
        -0.5f, -0.5f, 0.0f,   0.0f,  -1.0f, 0.0f,// bottom left
        -0.5f, -0.5f, 0.0f,   0.0f,  -1.0f, 0.0f,// bottom left
        -0.5f,  -0.5f, -0.5f, 0.0f,  -1.0f, 0.0f, // top left
        0.5f,  -0.5f, -0.5f,  0.0f,  -1.0f, 0.0f,// top right
    };
    
    return vertices;
}


//获取立方体和每个面的法向量 以及纹理贴图 长度216 +12 * 6 = 288
float* getCubeAndNoramlAndMapVertices(void) {
    //一共需要36个顶点（6个面 x 每个面有2个三角形组成 x 每个三角形有3个顶点）
    static float vertices[] = {
        // z轴上的两个平行面
        //前平面                法向量              纹理
        0.5f,  0.5f, 0.0f,   0.0f,  0.0f, 1.0f,  1.0f,1.0f, // top right
        0.5f, -0.5f, 0.0f,   0.0f,  0.0f, 1.0f,  1.0f,0.0f,// bottom right
        -0.5f, -0.5f, 0.0f,  0.0f,  0.0f, 1.0f,  0.0f,0.0f,// bottom left
        -0.5f, -0.5f, 0.0f,  0.0f,  0.0f, 1.0f,  0.0f,0.0f,// bottom left
        -0.5f,  0.5f, 0.0f,  0.0f,  0.0f, 1.0f,  1.0f,0.0f,// top left
        0.5f,  0.5f, 0.0f,   0.0f,  0.0f, 1.0f,  1.0f,1.0f,// top right
        
        //后平面
        0.5f,  0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  1.0f,1.0f,// top right
        0.5f, -0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  1.0f,0.0f,// bottom right
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f,0.0f,// bottom left
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f,0.0f,// bottom left
        -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f,0.0f,// top left
        0.5f,  0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  1.0f,1.0f,// top right
        
        // x轴上的两个平行面
        //右平面
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f, 0.0f,  1.0f,1.0f,// top right
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f, 0.0f,  1.0f,0.0f,// bottom right
        0.5f, -0.5f, 0.0f,   1.0f,  0.0f, 0.0f,  0.0f,0.0f,// bottom left
        0.5f, -0.5f, 0.0f,   1.0f,  0.0f, 0.0f,  0.0f,0.0f,// bottom left
        0.5f,  0.5f, 0.0f,   1.0f,  0.0f, 0.0f,  1.0f,0.0f,// top left
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f, 0.0f,  1.0f,1.0f,// top right
        
        //左平面 留个缺口，不留缺口可将y轴的0.0f改为-0.5f
        -0.5f,  0.5f, -0.5f,  -1.0f,  0.0f, 0.0f,  1.0f,1.0f,// top right
        -0.5f, 0.0f, -0.5f,   -1.0f,  0.0f, 0.0f,  1.0f,0.0f,// bottom right
        -0.5f, 0.0f, 0.0f,    -1.0f,  0.0f, 0.0f,  0.0f,0.0f,// bottom left
        -0.5f, 0.0f, 0.0f,    -1.0f,  0.0f, 0.0f,  0.0f,0.0f,// bottom left
        -0.5f,  0.5f, 0.0f,   -1.0f,  0.0f, 0.0f,  1.0f,0.0f,// top left
        -0.5f,  0.5f, -0.5f,  -1.0f,  0.0f, 0.0f,  1.0f,1.0f,// top right
        
        // y轴上的两个平行面
        //上平面
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f, 0.0f,  1.0f,1.0f,// top right
        0.5f, 0.5f, 0.0f,    0.0f,  1.0f, 0.0f,  1.0f,0.0f,// bottom right
        -0.5f, 0.5f, 0.0f,   0.0f,  1.0f, 0.0f,  0.0f,0.0f,// bottom left
        -0.5f, 0.5f, 0.0f,   0.0f,  1.0f, 0.0f,  0.0f,0.0f,// bottom left
        -0.5f,  0.5f, -0.5f, 0.0f,  1.0f, 0.0f,  1.0f,0.0f,// top left
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f, 0.0f,  1.0f,1.0f,// top right
        
        //下平面
        0.5f,  -0.5f, -0.5f,  0.0f,  -1.0f, 0.0f,  1.0f,1.0f,// top right
        0.5f, -0.5f, 0.0f,    0.0f,  -1.0f, 0.0f,  1.0f,0.0f,// bottom right
        -0.5f, -0.5f, 0.0f,   0.0f,  -1.0f, 0.0f,  0.0f,0.0f,// bottom left
        -0.5f, -0.5f, 0.0f,   0.0f,  -1.0f, 0.0f,  0.0f,0.0f,// bottom left
        -0.5f,  -0.5f, -0.5f, 0.0f,  -1.0f, 0.0f,  1.0f,0.0f,// top left
        0.5f,  -0.5f, -0.5f,  0.0f,  -1.0f, 0.0f,  1.0f,1.0f,// top right
    };
    
    return vertices;
}
