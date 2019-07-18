//
//  ViewController.m
//  TextDetector
//
//  Created by Megatron on 2019/7/17.
//  Copyright © 2019 SaturdayNight. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Vision/Vision.h>
#import "VNDetectFaceRectanglesManager.h"
#import "VNDetectTextRectanglesManager.h"

@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic,strong) UIView *containerView;                         // 视频播放容器
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) VNDetectFaceRectanglesManager *detectFaceRectanglesManager;
@property (nonatomic,strong) VNDetectTextRectanglesManager *detectTextRectanglesManager;

@property (nonatomic,strong) UILabel *lb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.containerView];
    self.containerView.center = self.view.center;
    self.containerView.bounds = CGRectMake(0, 0, 300, 300);
    
    [self.containerView.layer addSublayer:self.previewLayer];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self.session startRunning];
}

- (void)viewDidLayoutSubviews{
    self.containerView.layer.sublayers[0].frame = self.containerView.bounds;
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVImageBufferRef imgBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:imgBuffer orientation:kCGImagePropertyOrientationRightMirrored options:@{}];
    [handler performRequests:@[self.detectFaceRectanglesManager.faceRectanglesRequest] error:nil];
    //[handler performRequests:@[self.detectTextRectanglesManager.textRectanglesRequest] error:nil];
}
    
//MARK: - LazyLoad
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        
        AVCaptureVideoDataOutput *captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        NSString *yourFriendlyNSString = (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey;
        captureVideoDataOutput.videoSettings = @{yourFriendlyNSString:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
        [captureVideoDataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];
        
        [_session addInput:captureDeviceInput];
        [_session addOutput:captureVideoDataOutput];
    }
    
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];// 设置预览层信息
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _previewLayer.position = CGPointMake(150, 150);
    }
    
    return _previewLayer;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    
    return _containerView;
}

- (VNDetectFaceRectanglesManager *)detectFaceRectanglesManager{
    if (!_detectFaceRectanglesManager) {
        _detectFaceRectanglesManager = [[VNDetectFaceRectanglesManager alloc] init];
        [_detectFaceRectanglesManager setBindShowView:self.containerView];
    }
    
    return _detectFaceRectanglesManager;
}

- (VNDetectTextRectanglesManager *)detectTextRectanglesManager{
    if (!_detectTextRectanglesManager) {
        _detectTextRectanglesManager = [[VNDetectTextRectanglesManager alloc] init];
        [_detectTextRectanglesManager setBindShowView:self.containerView];
    }
    
    return _detectTextRectanglesManager;
}

@end
