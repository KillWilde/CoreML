//
//  VNDetectFaceRectanglesManager.h
//  TextDetector
//
//  Created by Megatron on 2019/7/18.
//  Copyright © 2019 SaturdayNight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VNDetectFaceRectanglesRequest;

NS_ASSUME_NONNULL_BEGIN

// 人脸实时检测
@interface VNDetectFaceRectanglesManager : NSObject

@property (nonatomic,strong) VNDetectFaceRectanglesRequest *faceRectanglesRequest;          // 人脸检测请求

- (void)setBindShowView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
