//
//  GlVideoFrameYUVModel.h
//  GlOpenGlESDemo
//
//  Created by gleeeli on 2019/7/10.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "GlVideoFrameModel.h"

@interface GlVideoFrameYUVModel : GlVideoFrameModel
@property (nonatomic, strong) NSData *lumaY;
@property (nonatomic, strong) NSData *chrominanceU;
@property (nonatomic, strong) NSData *chromaV;

@end

