//
//  QrCodeViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 20 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "QrCodeViewController.h"
# import <AVFoundation/AVFoundation.h>

@interface QrCodeViewController ()
// this is a private interface

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captureSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
