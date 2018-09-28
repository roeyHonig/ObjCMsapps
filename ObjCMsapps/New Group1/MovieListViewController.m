//
//  MovieListViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "MovieListViewController.h"
#import "Movie.h"
#import "MovieCellTableViewCell.h"
#import "MovieDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovieListViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) NSMutableArray * moviesCollection;
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    [self.moviesTableView reloadData];
    
    NSLog(@"MovieListController says:  %d", ((Movie *) _moviesCollection[2]).releaseYear); //   how to cast

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[MovieDetailsViewController class]]) {
        NSLog(@"next screen is the movie Details so prepere");
        MovieDetailsViewController *tmpMovieDetailsViewController = (MovieDetailsViewController *)([segue destinationViewController]);
        
        Movie *movieOfTheSelectedCell = ((MovieCellTableViewCell *) sender).specificMovieInfo;
        
        tmpMovieDetailsViewController.moviesHeader = movieOfTheSelectedCell;
        /*
        tmpMovieListViewController.moviesCollection = [[NSMutableArray alloc] init];
        tmpMovieListViewController.moviesCollection = self.moviesCollection;
        */
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCellTableViewCell *cell = (MovieCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    
    cell.movieTitleLabel.text = [NSString stringWithFormat:@"%@ (%d)",((Movie *)self.moviesCollection[indexPath.row]).title,((Movie *)self.moviesCollection[indexPath.row]).releaseYear];
    
    NSString *imageUrl = ((Movie *)self.moviesCollection[indexPath.row]).image;
    [cell.movieThumbNailImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icons8-short_filled"]]; //TODO: replace the placeHolderImage to something else
    
    cell.specificMovieInfo = ((Movie *)self.moviesCollection[indexPath.row]);
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.moviesCollection count];
}


@end
