//
//  Movie.h
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *ID;
@property(nonatomic) int year;
@property(strong, nonatomic) NSString *rating;
@property(nonatomic) int runtime;
@property(strong, nonatomic) NSString *theater_release_date;
@property(strong, nonatomic) NSString *dvd_release_date;
@property(nonatomic) int audience_score;
@property(nonatomic) int critics_score;
@property(strong, nonatomic) NSString *thumbnails_link;
@property(strong, nonatomic) NSString *synopsis;
-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
