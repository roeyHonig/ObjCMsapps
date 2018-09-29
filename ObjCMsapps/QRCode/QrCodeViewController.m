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
    
    NSError *error;
    self.captureSession = nil;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetaDataOutput];
    
    // setup what kind of data (output we're expecting) - QR Code in our case
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetaDataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetaDataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // show the user what the camera sees
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame: self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    // start the session
    [_captureSession startRunning];
}

- (void) captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects !=nil && [metadataObjects count] > 0) {
        // we have data
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // we have a QR code let's do something with it
            // but remember our session code is currentlly running on a secondary thread so we need
            // to post things back in the main queue
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithMeassege:[metadataObj stringValue]];
               
            });
        }
    }
}

- (void) showAlertWithMeassege: (NSString *) massage{
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"Warning" message:massage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //completion code
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // cpmetin code
    }];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
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
