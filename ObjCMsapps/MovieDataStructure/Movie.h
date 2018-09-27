//
//  Movie.h
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject 

@property NSString *title;
@property NSString *image;
@property double rating;
@property int releaseYear;
@property NSArray *genre;


 // normal init
- (instancetype) initWithTitle: (NSString*) title
                   andImageUrl: (NSString*) image
                   andRating: (double) rating
                   andReleaseYear: (int) releaseYear
                   andGenre: (NSArray*) genre;


@end
