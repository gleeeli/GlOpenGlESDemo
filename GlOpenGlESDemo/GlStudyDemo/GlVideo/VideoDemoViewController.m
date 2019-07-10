//
//  VideoDemoViewController.m
//  GlOpenGlESDemo
//
//  Created by 小柠檬 on 2019/7/10.
//  Copyright © 2019 gleeeli. All rights reserved.
//

#import "VideoDemoViewController.h"
#import "GlVideoFrameYUVModel.h"
#import "GlVideoFrameView.h"
#import "CommHeader.h"

#define YUV_Width 176
#define YUV_Height 144

@interface VideoDemoViewController ()
@property (nonatomic, strong) GlVideoFrameView *glView;

@property (nonatomic, strong)  GlVideoFrameYUVModel *model;
@end

@implementation VideoDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger widht = YUV_Width;
    NSUInteger height = YUV_Height;
    
    CGFloat glheight = SCREEN_WIDTH / widht * height;
    
    self.glView = [[GlVideoFrameView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, glheight)];
    [self.view addSubview:self.glView];
    
    //decode_video720x480YUV420P
    NSString *inputFilePath = [[NSBundle mainBundle] pathForResource:@"176x144_yuv420p" ofType:@"yuv"];
    const char *yuvFilePath = [inputFilePath UTF8String];
    unsigned char *buffer = readYUV(yuvFilePath);
    
    
    NSUInteger ylenght = widht * height;
    
    NSData *dataY = [NSData dataWithBytes:buffer length:ylenght];
    NSData *dataU = [NSData dataWithBytes:buffer+ylenght length:ylenght/4];
    NSData *dataV = [NSData dataWithBytes:buffer+ylenght*5/4 length:ylenght/4];
    
    _model = [[GlVideoFrameYUVModel alloc] init];
    _model.width = widht;
    _model.height = height;
    
    _model.lumaY = dataY;
    _model.chrominanceU = dataU;
    _model.chromaV = dataV;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.glView updateFrameTexture:_model];
}

static unsigned char * readYUV(const char *path)
{
    
    FILE *fp;
    unsigned char * buffer;
    long size = YUV_Width * YUV_Height * 3 / 2;
    
    if((fp=fopen(path,"rb"))==NULL)
    {
        printf("cant open the file");
        exit(0);
    }
    
    buffer = (unsigned char *)malloc(size);
    memset(buffer,'\0',size);
    long len = fread(buffer,1,size,fp);
    //PRINTF("read data size:%ld", len);
    fclose(fp);
    return buffer;
}

@end
