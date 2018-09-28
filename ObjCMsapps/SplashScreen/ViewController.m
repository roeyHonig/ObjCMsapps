//
//  ViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "Movie.h"
#import "MovieListViewController.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray * moviesCollection;
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
    
    // init properties
    self.moviesCollection = [[NSMutableArray alloc] init];
    
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseJsonFromFollowingUrl:(NSString *) apiUrl{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *artificialMoviesCollection = [self getMovieCollectionManually]; // should be retrived online by URLSession
    for (Movie *movie in artificialMoviesCollection) {
        // itearate and save into coreData
        [appDelegate saveMovieWithTitle:movie.title withPosterImageUrl:movie.image withRating:movie.rating withReleaseYear:movie.releaseYear withGenre:movie.genre];
    }
    
    // read coreData and append to this class local self.moviesCollection
    NSMutableArray *moviesCollectionFromCoreData = [appDelegate readCoreData];
    for (Movie *movie in moviesCollectionFromCoreData) {
        [self.moviesCollection addObject:movie];
    }
    
    // proceed to next screen
    [self performSegueWithIdentifier:@"goToMovieListSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
        NSLog(@"next screen is the movie list so prepere");
        MovieListViewController *tmpMovieListViewController = (MovieListViewController *)(([((UINavigationController *)[segue destinationViewController]) viewControllers])[0]);
        tmpMovieListViewController.moviesCollection = [[NSMutableArray alloc] init];
        tmpMovieListViewController.moviesCollection = self.moviesCollection;
        
    }
}



- (NSMutableArray *) getMovieCollectionManually {
    NSMutableArray *artificalMovieCollection = [[NSMutableArray alloc] init];
    
    Movie *movie1 = [[Movie alloc] initWithTitle:@"roadRunner" andImageUrl:@"https://api.androidhive.info/json/movies/1.jpg" andRating: 9.7 andReleaseYear:1992 andGenre:@[@"horror", @"comedy"]];
    [artificalMovieCollection addObject: movie1];
    
    Movie *movie2 = [[Movie alloc] initWithTitle:@"termaniator" andImageUrl:@"https://api.androidhive.info/json/movies/2.jpg" andRating: 5.7 andReleaseYear:1982 andGenre:@[@"horror", @"comedy", @"drama"]];
    [artificalMovieCollection addObject: movie2];
    
    Movie *movie3 = [[Movie alloc] initWithTitle:@"friends" andImageUrl:@"https://api.androidhive.info/json/movies/3.jpg" andRating: 7.2 andReleaseYear:1987 andGenre:@[@"horror", @"musical", @"drama"]];
    [artificalMovieCollection addObject: movie3];
    
    return artificalMovieCollection;
}

@end
