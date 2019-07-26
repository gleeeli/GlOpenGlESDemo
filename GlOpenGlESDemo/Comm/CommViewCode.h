//
//  CommViewCode.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/5/17.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommViewCode : NSObject
/**
 获取图片二进制 以及宽高
 
 @param imgName 图片名
 */
+ (GLubyte *)getDataFromImg:(NSString *)imgName width:(float *)width height:(float *)height;
@end

NS_ASSUME_NONNULL_END
