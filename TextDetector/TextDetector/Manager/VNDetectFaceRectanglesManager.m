//
//  VNDetectFaceRectanglesManager.m
//  TextDetector
//
//  Created by Megatron on 2019/7/18.
//  Copyright © 2019 SaturdayNight. All rights reserved.
//

#import "VNDetectFaceRectanglesManager.h"
#import <Vision/Vision.h>

@interface VNDetectFaceRectanglesManager ()

@property (nonatomic,weak) UIView *containerView;                                                // 外层实时视频展示视图
@property (nonatomic,strong) UILabel *lb;

@end

@implementation VNDetectFaceRectanglesManager

- (void)setBindShowView:(UIView *)view{
    self.containerView = view;
}

// 展示人脸框框
- (void)showFace:(VNFaceObservation *)faceObservation{
    CGFloat x = faceObservation.boundingBox.origin.x * self.containerView.frame.size.width;
    CGFloat y = faceObservation.boundingBox.origin.y * self.containerView.frame.size.height;
    CGFloat w = faceObservation.boundingBox.size.width * self.containerView.frame.size.width;
    CGFloat h = faceObservation.boundingBox.size.height * self.containerView.frame.size.height;
    
    CGRect rect = CGRectMake(x,y,w,h);
    
    CALayer *outLineLayer = [[CALayer alloc] init];
    outLineLayer.frame = rect;
    outLineLayer.borderWidth = 1.0;
    outLineLayer.borderColor = [UIColor redColor].CGColor;
    
    self.lb = [[UILabel alloc] init];
    self.lb.textColor = [UIColor redColor];
    self.lb.text = @"90%一只猪\n10%一个傻子";
    self.lb.numberOfLines = 2;
    self.lb.font = [UIFont systemFontOfSize:12];
    [self.lb sizeToFit];
    self.lb.layer.frame = CGRectMake(x+w, y+h, 100, 50);
    
    [self.containerView.layer addSublayer:outLineLayer];
    [self.containerView.layer addSublayer:self.lb.layer];
}

//MARK: - LazyLoad
- (VNDetectFaceRectanglesRequest *)faceRectanglesRequest{
    if (!_faceRectanglesRequest) {
        _faceRectanglesRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            // 识别到人脸信息回调
            if (request && request.results > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 新数据返回时 移除上一次添加的视图
                    for (int i = 1; i < self.containerView.layer.sublayers.count; i++) {
                        [[self.containerView.layer.sublayers objectAtIndex:i] removeFromSuperlayer];
                    }
                    
                    // 添加新视图
                    for (int i = 0; i < request.results.count; i++) {
                        id object = [request.results objectAtIndex:i];
                        [self showFace:object];
                    }
                });
            }
        }];
        
    }
    
    return _faceRectanglesRequest;
}

@end
