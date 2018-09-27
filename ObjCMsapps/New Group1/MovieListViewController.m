//
//  MovieListViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "MovieListViewController.h"
#import "Movie.h"

@interface MovieListViewController ()

//@property (strong, nonatomic) NSMutableArray * moviesCollection;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"MovieListController says:  %d", ((Movie *) _moviesCollection[2]).releaseYear); //   how to cast

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
