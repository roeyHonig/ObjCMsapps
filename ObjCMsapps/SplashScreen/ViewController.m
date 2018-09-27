//
//  ViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Splash Animation to let the user know the App is running while data is retrived from the internet
    [UIView animateWithDuration: 1 delay: 0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^(void){
        self.welcomeLabel.alpha = 0;
    } completion:nil];
    
    // WorkAround to have some delay, so the user will see the splash screen and not jump right away to Movie List
    [UIView animateWithDuration: 6 delay: 0 options: UIViewAnimationOptionCurveEaseIn animations:^(void){
        self.view.alpha = 0.999; // insignicant change, just to make the animation runs
    } completion:^(BOOL finished){
        // retrive data online, save in core data (if needed), read core data and when cpmplete -> go to the next screen
        [self parseJsonFromFollowingUrl: @"https://api.androidhive.info/json/movies.json"];
    } ];
    
    
    Movie *movie1 = [[Movie alloc] initWithTitle:@"roadRunner" andImageUrl:@"someImageUrl" andRating: 9.7 andReleaseYear:1992 andGenre:@[@"horror", @"comedy"]];
    NSLog(@"movie number 1 is: %@", movie1.genre);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseJsonFromFollowingUrl:(NSString *) apiUrl{
    [self performSegueWithIdentifier:@"goToMovieListSegue" sender:self];
}


@end
