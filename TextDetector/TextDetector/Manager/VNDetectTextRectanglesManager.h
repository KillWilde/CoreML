//
//  VNDetectTextRectanglesManager.h
//  TextDetector
//
//  Created by Megatron on 2019/7/18.
//  Copyright © 2019 SaturdayNight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VNDetectTextRectanglesRequest;

NS_ASSUME_NONNULL_BEGIN

@interface VNDetectTextRectanglesManager : NSObject

@property (nonatomic,strong) VNDetectTextRectanglesRequest *textRectanglesRequest;

- (void)setBindShowView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
