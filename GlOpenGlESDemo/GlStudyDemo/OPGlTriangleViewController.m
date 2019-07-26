//
//  OPGlTriangleViewController.m
//  LearnOpenGLES
//
//  Created by gleeeli on 2019/2/28.
//  Copyright © 2019年 林伟池. All rights reserved.
//

#import "OPGlTriangleViewController.h"
#import <OpenGLES/ES2/glext.h>

@interface OPGlTriangleViewController ()
@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;
@end

@implementation OPGlTriangleViewController
{
    int shaderProgram;
    unsigned int VAO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //2.0，还有1.0和3.0
    
    if (!self.mContext) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
    
    //将顶点坐标赋值给gl_Position
    const char *vertexShaderSource = "attribute vec3 Position;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(Position.x, Position.y, Position.z, 1.0);\n"
    "}\0";
    
    //固定颜色值
    const char *fragmentShaderSource = "void main()\n"
    "{\n"
    "   gl_FragColor = vec4(1.0, 0.5, 0.2, 1.0);\n"
    "}\0";
    
    int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        NSLog(@"Failed to shader vertexShaderSource");
    }
    
    int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    // check for shader compile errors
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        NSLog(@"Failed to shader fragmentShaderSource");
    }
    
    // link shaders
    shaderProgram = glCreateProgram();//int
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    // check for linking errors
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        NSLog(@"Failed to link shaderProgram");
    }
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    float vertices[] = {
        -0.5f, -0.5f, 0.0f, // left
        0.5f, -0.5f, 0.0f, // right
        0.0f,  0.5f, 0.0f  // top
    };
    
    unsigned int VBO;//
    glGenVertexArraysOES(1, &VAO);//顶点数组对象
    //一个缓冲ID生成一个VBO对象
    glGenBuffers(1, &VBO);
    
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArrayOES(VAO);
    
    //顶点缓冲对象的缓冲类型是GL_ARRAY_BUFFER
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    /**
     * GL_STATIC_DRAW ：数据不会或几乎不会改变。
     * GL_DYNAMIC_DRAW：数据会被改变很多。
     * GL_STREAM_DRAW ：数据每次绘制时都会改变。
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //启用顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //我们必须在渲染前指定OpenGL该如何解释顶点数据。第二个参数：顶点属性是一个vec3，它由3个值组成，所以大小是3。
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    
    // note that this is allowed, the call to glVertexAttribPointer registered VBO as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // You can unbind the VAO afterwards so other VAO calls won't accidentally modify this VAO, but this rarely happens. Modifying other
    // VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
    glBindVertexArrayOES(0);
}

/**
 *  场景数据变化
 */
- (void)update {
    
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // draw our first triangle
    glUseProgram(shaderProgram);
    glBindVertexArrayOES(VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
    //GL_TRIANGLES：每三个顶之间绘制三角形，之间不连接 参数2：从数组缓存中的哪一位开始绘制，一般都定义为0 参数3：顶点的数量
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
