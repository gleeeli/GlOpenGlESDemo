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
#endif /* CommVertices_h */
