//
//  Movie.m
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype) initWithTitle:(NSString *)title andImageUrl:(NSString *)image andRating:(double)rating andReleaseYear:(int)releaseYear andGenre:(NSArray *)genre
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.rating = rating;
        self.releaseYear = releaseYear;
        self.genre = genre;
        
    }
    return self;
}


@end
