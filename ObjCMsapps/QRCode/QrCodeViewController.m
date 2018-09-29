//
//  QrCodeViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 20 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//
//This is the correct format for generating QR Code using a text string to be later read by the QR scanner and correctlly decoded
//   {"title":"Planet of the Apes","genre":["Action"],"image":"https:\/\/api.androidhive.info\/json\/movies\/1.jpg","rating":8.300000000000001,"releaseYear":2019}

#import "QrCodeViewController.h"
# import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Movie.h"
#import "MovieListViewController.h"


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
    //[_captureSession startRunning];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_captureSession startRunning];
}

- (void) captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects !=nil && [metadataObjects count] > 0) {
        // we have data
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // we have a QR code let's do something with it
            // 1st let's stop the session
            [self.captureSession stopRunning];
            // but remember our session code is currentlly running on a secondary thread so we need
            // to post things back in the main queue
           
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *jsonError;
                NSData *data = [[metadataObj stringValue] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSLog(@"qr code image url is: %@", [jsonResponse valueForKey:@"image"]);
                
                NSString *tmpTitle = (NSString *)([jsonResponse valueForKey:@"title"]);
                NSString *tmpImage = (NSString *)([jsonResponse valueForKey:@"image"]);
                double tmpRating = [[jsonResponse valueForKey:@"rating"] doubleValue];
                int tmpReleaseYear = [[jsonResponse valueForKey:@"releaseYear"] integerValue];
                NSArray *tmpgenre = (NSArray *)([jsonResponse valueForKey:@"genre"]);
                
                Movie *newMovieFromQRCode = [[Movie alloc] initWithTitle:tmpTitle andImageUrl:tmpImage andRating:tmpRating andReleaseYear:tmpReleaseYear andGenre:tmpgenre];
                NSString *alertMassage = [[NSString alloc] initWithFormat:@"Would you like to add \"%@\" to your list?", newMovieFromQRCode.title];
                
                [self showAlertWithMeassege:alertMassage aboutAddingTheNewMovie:newMovieFromQRCode];
               
            });
        }
    }
}

- (void) showAlertWithMeassege: (NSString *) massage aboutAddingTheNewMovie: (Movie *) movie{
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"Warning" message:massage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //completion code
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate saveMovieWithTitle:movie.title withPosterImageUrl:movie.image withRating:movie.rating withReleaseYear:movie.releaseYear withGenre:movie.genre];
        
        //re-read the core data
        NSMutableArray *moviesCollectionFromCoreData = [appDelegate readCoreData];
        NSMutableArray *moviesToPassToMovieListController = [[NSMutableArray alloc] init];
        for (Movie *movie in moviesCollectionFromCoreData) {
            [moviesToPassToMovieListController addObject:movie];
        }
        
        MovieListViewController *tmpMovieListViewController = (MovieListViewController *)([[self navigationController] viewControllers][0]);
        
        tmpMovieListViewController.moviesCollection = moviesToPassToMovieListController;
        
        [[self navigationController] popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // cpmpletion code
        
        [[self navigationController] popViewControllerAnimated:YES];
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
