//
//  Movie.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "Movie.h"
@interface Movie()

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







@end
@implementation Movie
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.title = [dictionary objectForKey:@"title"];
        self.ID =[dictionary objectForKey:@"id"];
        self.year = [[dictionary objectForKey:@"year"] intValue];
        self.rating =[dictionary objectForKey:@"mpaa_rating"];
        self.runtime = [[dictionary objectForKey:@"runtime"] intValue];
        
        NSDictionary* relDateDict = [dictionary objectForKey:@"release_dates"] ;
        if ( [relDateDict objectForKey:@"theater"] != nil) {
            self.theater_release_date = [relDateDict objectForKey:@"theater"];
        }
        NSDictionary* ratingDict = [dictionary objectForKey:@"ratings"] ;
        if ( [ratingDict objectForKey:@"audience_score"] != nil) {
            self.audience_score = [[relDateDict objectForKey:@"audience_score"] intValue];
        }
        if ( [ratingDict objectForKey:@"critics_score"] != nil) {
            self.critics_score = [[relDateDict objectForKey:@"critics_score"] intValue];
        }
        
        NSDictionary* posterDict = [dictionary objectForKey:@"posters"];
        self.thumbnails_link = [posterDict objectForKey:@"thumbnail"];
    }
    return self;
}
@end
