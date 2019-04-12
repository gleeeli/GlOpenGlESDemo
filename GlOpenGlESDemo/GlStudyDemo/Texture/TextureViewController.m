//
//  TextureViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/3/4.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "TextureViewController.h"

@interface TextureViewController ()

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handleVertex];
    
    [self loadTexture];
}

- (void)initBaseInfo {
    self.vsFileName = @"texture_shaderv";
    self.fsFileName = @"texture_shaderf";
}

- (void)handleVertex {
    NSLog(@"handle vertex");
    float vertices[] = {
        // positions          // colors           // texture coords
        0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f,   1.0f, 1.0f, // top right
        0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f,   1.0f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,   0.0f, 0.0f, // bottom left
        -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f,   0.0f, 1.0f  // top left
    };
    unsigned int indices[] = {
        0, 1, 3, // first triangle
        1, 2, 3  // second triangle
    };
    unsigned int VBO,EBO;
    glGenVertexArraysOES(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    
    glBindVertexArrayOES(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // position attribute
    GLuint position = glGetAttribLocation(shaderProgram, "aPos");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(position);
    // color attribute
    GLuint aColor = glGetAttribLocation(shaderProgram, "aColor");
    glVertexAttribPointer(aColor, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(aColor);
    // texture coord attribute
    GLuint aTexCoord = glGetAttribLocation(shaderProgram, "aTexCoord");
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(6 * sizeof(float)));
    glEnableVertexAttribArray(aTexCoord);
}

//创建以及加载纹理
- (void)loadTexture {
    NSLog(@"加载纹理-loadTexture");
    //得到图片二进制
    float width;
    float height;
    GLubyte * spriteData = [self getDataFromImg:@"fengjing" width:&width height:&height];
    
    
    glGenTextures(1, &_myTexture);
    glBindTexture(GL_TEXTURE_2D, self.myTexture);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    //第二个参数为纹理指定多级渐远纹理的级别，如果你希望单独手动设置每个多级渐远纹理的级别的话。这里我们填0，也就是基本级别。
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    free(spriteData);
}

- (BOOL)initBaseShader {
    
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    //创建着色器程序
    shaderProgram = glCreateProgram();
    
    // 创建 编译顶点着色器
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:self.vsFileName ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // 创建 编译片段着色器
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:self.fsFileName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(shaderProgram, vertShader);
    glAttachShader(shaderProgram, fragShader);
    
    // 链接程序
    if (![self linkProgram:shaderProgram]) {
        NSLog(@"Failed to link program: %d", shaderProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (shaderProgram) {
            glDeleteProgram(shaderProgram);
            shaderProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(shaderProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(shaderProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

/**
 获取图片二进制 以及宽高
 
 @param imgName 图片名
 */
- (GLubyte *)getDataFromImg:(NSString *)imgName width:(float *)width height:(float *)height {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:imgName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", imgName);
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width_s = CGImageGetWidth(spriteImage);
    size_t height_s = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width_s * height_s * 4, sizeof(GLubyte));////rgba共4个byte
    
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width_s, height_s,
                                                       8,//内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
                                                       width_s*4,//bitmap的每一行在内存所占的比特数
                                                       CGImageGetColorSpace(spriteImage),//bitmap上下文使用的颜色空间。
                                                       kCGImageAlphaPremultipliedLast);//指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width_s, height_s), spriteImage);
    CGContextRelease(spriteContext);
    *width = width_s;
    *height = height_s;
    
    return spriteData;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // bind Texture
    glBindTexture(GL_TEXTURE_2D, self.myTexture);
    
    [self useProgram];
    glBindVertexArrayOES(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}

/*
 第一个参数指定了纹理目标；我们使用的是2D纹理，因此纹理目标是GL_TEXTURE_2D。
 第二个参数需要我们指定设置的选项与应用的纹理轴
 第三个参数传递一个环绕方式
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
 
 GL_REPEAT    对纹理的默认行为。重复纹理图像。
 GL_MIRRORED_REPEAT    和GL_REPEAT一样，但每次重复图片是镜像放置的。
 GL_CLAMP_TO_EDGE    纹理坐标会被约束在0到1之间，超出的部分会重复纹理坐标的边缘，产生一种边缘被拉伸的效果。
 GL_CLAMP_TO_BORDER    超出的坐标为用户指定的边缘颜色。
 
 （GL_CLAMP_TO_BORDER 此方式多传一个参数：
 float borderColor[] = { 1.0f, 1.0f, 0.0f, 1.0f };
 glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);）
 
 
 纹理过滤：（处理放大缩小）
 GL_NEAREST（也叫邻近过滤，Nearest Neighbor Filtering，清晰，但有锯齿感）是OpenGL默认的纹理过滤方式。当设置为GL_NEAREST的时候，OpenGL会选择中心点最接近纹理坐标的那个像素。下图中你可以看到四个像素，加号代表纹理坐标。左上角那个纹理像素的中心距离纹理坐标最近，所以它会被选择为样本颜色：
 GL_LINEAR（也叫线性过滤，(Bi)linear Filtering，模糊化，平滑）它会基于纹理坐标附近的纹理像素，计算出一个插值，近似出这些纹理像素之间的颜色。一个纹理像素的中心距离纹理坐标越近，那么这个纹理像素的颜色对最终的样本颜色的贡献越大。下图中你可以看到返回的颜色是邻近像素的混合色
 
 当进行放大(Magnify)和缩小(Minify)操作的时候可以设置纹理过滤的选项
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
 
 
 多级渐远纹理 Mipmap：（很小东西，分辨率高，但opengl可能只需显示一个像素，该取哪个？）
 它简单来说就是一系列的纹理图像，后一个纹理图像是前一个的二分之一。
 距观察者的距离超过一定的阈值，OpenGL会使用不同的多级渐远纹理，即最适合物体的距离的那个
 
 指定不同多级渐远纹理级别之间的过滤方式：
 GL_NEAREST_MIPMAP_NEAREST    使用最邻近的多级渐远纹理来匹配像素大小，并使用邻近插值进行纹理采样
 GL_LINEAR_MIPMAP_NEAREST    使用最邻近的多级渐远纹理级别，并使用线性插值进行采样
 GL_NEAREST_MIPMAP_LINEAR    在两个最匹配像素大小的多级渐远纹理之间进行线性插值，使用邻近插值进行采样
 GL_LINEAR_MIPMAP_LINEAR    在两个邻近的多级渐远纹理之间使用线性插值，并使用线性插值进行采样
 
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
 */
@end
