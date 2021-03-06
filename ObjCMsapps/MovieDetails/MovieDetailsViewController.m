//
//  MovieDetailsViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 19 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "MovieListViewController.h"




@interface MovieDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *posterImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *releaseYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;


@end

@implementation MovieDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDisplayElementsOfThisScreen];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"presenting movie titled: %@", self.moviesHeader.genre);
}

- (void) initDisplayElementsOfThisScreen {
    NSString *txtForTitleLabel = [NSString stringWithFormat:@"Title: %@", self.moviesHeader.title];
    self.titleLabel.text = txtForTitleLabel;
    
    NSString *txtForRatingLabel = [NSString stringWithFormat:@"Rating: %.1lf", self.moviesHeader.rating];
    self.ratingLabel.text = txtForRatingLabel;
    
    NSString *txtForReleaseYearLabel = [NSString stringWithFormat:@"Year Of Release: %d", self.moviesHeader.releaseYear];
    self.releaseYearLabel.text = txtForReleaseYearLabel;
    
    NSMutableString *txtForGenreLabel = [NSMutableString stringWithFormat:@"Genre: "];
    for (int i = 0; i < [self.moviesHeader.genre count]; i++) {
        // iterate
        if (i == 0) {
            //1st one
            [txtForGenreLabel appendString: (NSString *)(self.moviesHeader.genre[i])];
        } else {
            [txtForGenreLabel appendString:@", "];
            [txtForGenreLabel appendString: (NSString *)(self.moviesHeader.genre[i])];
        }
    }
    self.genreLabel.text = txtForGenreLabel;
    
    NSString *imageUrl = self.moviesHeader.image;
    [self.posterImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icons8-short_filled"]]; //TODO: replace the placeHolderImage to something else
    
    
}

- (IBAction)deleteThisMovie:(UIBarButtonItem *)sender {
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"Warning" message:@"Are You Sure you want to delete this movie from your list?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //completion code
        //TODO: delete from core data
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate deleteMovieFromCoreDataWithTheTitle:self.moviesHeader.title];
        
        //re-read the core data
        NSMutableArray *moviesCollectionFromCoreData = [appDelegate readCoreData];
        NSMutableArray *moviesToPassToMovieListController = [[NSMutableArray alloc] init];
        for (Movie *movie in moviesCollectionFromCoreData) {
            [moviesToPassToMovieListController addObject:movie];
        }
        
        MovieListViewController *tmpMovieListViewController = (MovieListViewController *)([[self navigationController] viewControllers][0]);
        
        tmpMovieListViewController.moviesCollection = moviesToPassToMovieListController;
        
        //TODO: go back to movie list
        [[self navigationController] popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
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
