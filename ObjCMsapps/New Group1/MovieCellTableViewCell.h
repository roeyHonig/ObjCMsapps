//
//  MovieCellTableViewCell.h
//  ObjCMsapps
//
//  Created by hackeru on 19 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *movieThumbNailImage;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) Movie *specificMovieInfo;



@end
