//
//  CommViewCode.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "CommViewCode.h"

@implementation CommViewCode
/**
 获取图片二进制 以及宽高
 
 @param imgName 图片名
 */
+ (GLubyte *)getDataFromImg:(NSString *)imgName width:(float *)width height:(float *)height {
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    colorSpace = CGImageGetColorSpace(spriteImage);
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width_s, height_s,
                                                       8,//内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
                                                       width_s*4,//bitmap的每一行在内存所占的比特数
                                                       colorSpace,//bitmap上下文使用的颜色空间。
                                                       kCGImageAlphaPremultipliedLast| kCGBitmapByteOrder32Big
                                                );//指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
    CGColorSpaceRelease(colorSpace);
    
    CGContextTranslateCTM(spriteContext, 0.0F, height_s);
    CGContextScaleCTM(spriteContext, 1.0F, -1.0F);
    CGContextSetBlendMode(spriteContext, kCGBlendModeCopy);
    
    CGContextClearRect( spriteContext, CGRectMake( 0, 0, width_s, height_s ) );
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width_s, height_s), spriteImage);
    
    
    CGContextRelease(spriteContext);
    *width = width_s;
    *height = height_s;
    
    return spriteData;
}
@end
