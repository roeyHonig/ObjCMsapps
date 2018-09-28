//
//  MovieDetailsViewController.m
//  ObjCMsapps
//
//  Created by hackeru on 19 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "MovieDetailsViewController.h"


@interface MovieDetailsViewController ()



@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"presenting movie titled: %@", self.moviesHeader.title);
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
