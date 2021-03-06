//
//  CommShader.m
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "CommShader.h"
#import <OpenGLES/ES2/gl.h>
//#include <string>
//#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

@implementation CommShader

- (instancetype)initWithvsFileName:(NSString *)vsFileName fsFileName:(NSString *)fsFileName
{
    self = [super init];
    if (self) {
        BOOL result = [self initBaseShaderWithvsFileName:vsFileName fsFileName:fsFileName];
        NSLog(@"着色器初始化状态:%d",result);
    }
    
    return self;
}

- (BOOL)initBaseShaderWithvsFileName:(NSString *)vsFileName fsFileName:(NSString *)fsFileName{
    
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    //创建着色器程序
    _shaderProgram = glCreateProgram();
    
    // 创建 编译顶点着色器
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vsFileName ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // 创建 编译片段着色器
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fsFileName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(_shaderProgram, vertShader);
    glAttachShader(_shaderProgram, fragShader);
    
    // 链接程序
    if (![self linkProgram:_shaderProgram]) {
        NSLog(@"Failed to link program: %d", _shaderProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_shaderProgram) {
            glDeleteProgram(_shaderProgram);
            _shaderProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_shaderProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_shaderProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

//链接着色器程序
- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

/**
 _shaderProgram就是一个程序对象，我们可以调用glUseProgram函数，用刚创建的程序对象作为它的参数，以激活这个程序对象
 在glUseProgram函数调用之后，每个着色器调用和渲染调用都会使用这个程序对象（也就是之前写的着色器)了
 */
- (void)useProgram {
    glUseProgram(_shaderProgram);
}

- (void)deleteProgram {
    if (_shaderProgram) {
        glDeleteProgram(_shaderProgram);
        _shaderProgram = 0;
    }
}

- (void)setBool:(std::string)name boolv:(BOOL)boolv {
    glUniform1i(glGetUniformLocation(_shaderProgram, name.c_str()), (int)boolv);
}

- (void)setInt:(std::string)name intv:(int)intv {
   glUniform1i(glGetUniformLocation(_shaderProgram, name.c_str()), intv);
}
    
- (void)setFload:(std::string)name floatv:(float)floatv {
    glUniform1f(glGetUniformLocation(_shaderProgram, name.c_str()), floatv);
}

- (void)setVec2:(std::string)name vec2:(glm::vec3)vec2 {
    glUniform2fv(glGetUniformLocation(_shaderProgram, name.c_str()), 1, &vec2[0]);
}

- (void)setVec3:(std::string)name vec3:(glm::vec3)vec3{
    glUniform3fv(glGetUniformLocation(_shaderProgram, name.c_str()), 1, &vec3[0]);
}

- (void)setVec3:(std::string)name x:(float)x y:(float)y z:(float)z {
    glUniform3f(glGetUniformLocation(_shaderProgram, name.c_str()), x, y, z);
}

- (void)setMat2:(std::string  )name mat4:(glm::mat2 )mat2 {
   glUniformMatrix2fv(glGetUniformLocation(_shaderProgram, name.c_str()), 1, GL_FALSE, &mat2[0][0]);;
}

- (void)setMat4:(std::string  )name mat4:(glm::mat4 )mat4 {
    glUniformMatrix4fv(glGetUniformLocation(_shaderProgram, name.c_str()), 1, GL_FALSE, &mat4[0][0]);
}

- (void)dealloc {
    [self deleteProgram];
}
@end
