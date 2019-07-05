//
//  CommVertices.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/20.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#ifndef CommVertices_h
#define CommVertices_h

#include <stdio.h>
float * getCubeVertices(void);
//获取立方体和每个面的法向量
float* getCubeAndNoramlVertices(void);
//获取立方体和每个面的法向量 以及纹理贴图
float* getCubeAndNoramlAndMapVertices(void);
//获取立方体和纹理 以及纹理贴图 长度30 *6 = 180
float* getCubeAndTextureVertices(void);
//获取地板顶点和纹理 长度：30
float* getPlanVertices(void);
//长度：24
float* getQuadVertices(void);
#endif /* CommVertices_h */
