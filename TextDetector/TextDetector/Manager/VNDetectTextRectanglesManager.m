//
//  VNDetectTextRectanglesManager.m
//  TextDetector
//
//  Created by Megatron on 2019/7/18.
//  Copyright © 2019 SaturdayNight. All rights reserved.
//

#import "VNDetectTextRectanglesManager.h"
#import <Vision/Vision.h>

@interface VNDetectTextRectanglesManager ()

@property (nonatomic,weak) UIView *containerView;                                                // 外层实时视频展示视图

@end

@implementation VNDetectTextRectanglesManager

- (void)setBindShowView:(UIView *)view{
    self.containerView = view;
}

// 展示文字框
- (void)showOutLineWithObservation:(VNTextObservation *)textObservation{
    NSLog(@"cy %i",(int)textObservation.characterBoxes.count);
    
    CGFloat maxX = 0;
    CGFloat minX = 300;
    CGFloat maxY = 0;
    CGFloat minY = 300;
    
    for (int i = 0; i < textObservation.characterBoxes.count; i++) {
        VNRectangleObservation *rectangleObservation = [textObservation.characterBoxes objectAtIndex:i];
        
        CGFloat xCord = rectangleObservation.topLeft.x * self.containerView.frame.size.width;
        CGFloat yCord = rectangleObservation.topLeft.y * self.containerView.frame.size.height;
        CGFloat width = (rectangleObservation.topRight.x - rectangleObservation.bottomLeft.x) * self.containerView.frame.size.width;
        CGFloat height = (rectangleObservation.topLeft.y - rectangleObservation.bottomLeft.y) * self.containerView.frame.size.height;
        
        if (xCord+width > maxX) {
            maxX = xCord+width;
        }
        if (xCord < minX) {
            minX = xCord;
        }
        if (yCord+height > maxY) {
            maxY = yCord+height;
        }
        if (yCord < minY) {
            minY = yCord;
        }
        
        CALayer *outLineLayer = [[CALayer alloc] init];
        outLineLayer.frame = CGRectMake(xCord, yCord, width, height);
        outLineLayer.borderWidth = 1.0;
        outLineLayer.borderColor = [UIColor redColor].CGColor;
        
        [self.containerView.layer addSublayer:outLineLayer];
    }
    
    CALayer *outLineLayer = [[CALayer alloc] init];
    outLineLayer.frame = CGRectMake(minX, maxY, maxX - minX, maxY - minY);
    outLineLayer.borderWidth = 1.0;
    outLineLayer.borderColor = [UIColor yellowColor].CGColor;
    
    [self.containerView.layer addSublayer:outLineLayer];
}


//MARK: - LazyLoad
- (VNDetectTextRectanglesRequest *)textRectanglesRequest{
    if (!_textRectanglesRequest) {
        _textRectanglesRequest = [[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            if (request && request.results > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (int i = 1; i < self.containerView.layer.sublayers.count; i++) {
                        [[self.containerView.layer.sublayers objectAtIndex:i] removeFromSuperlayer];
                    }
                    
                    for (int i = 0; i < request.results.count; i++) {
                        id object = [request.results objectAtIndex:i];
                        [self showOutLineWithObservation:object];
                    }
                });
            }
        }];
        _textRectanglesRequest.reportCharacterBoxes = YES;
    }
    
    return _textRectanglesRequest;
}

@end

