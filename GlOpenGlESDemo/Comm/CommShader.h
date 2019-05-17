//
//  CommShader.h
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <glm/glm.hpp>
#include <string>

@interface CommShader : NSObject
@property (nonatomic, assign) int shaderProgram;

- (instancetype)initWithvsFileName:(NSString *)vsFileName fsFileName:(NSString *)fsFileName;
- (void)useProgram;

//带有C++类型的方法声明
#ifdef __cplusplus
- (void)setVec3:(std::string)name x:(float)x y:(float)y z:(float)z;
- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4;
#endif

@end
