//
//  Movie.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "Movie.h"
@interface Movie()

@end
@implementation Movie
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        //        NSLog(dictionary.description);
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
            self.audience_score = [[ratingDict objectForKey:@"audience_score"] intValue];
            //            NSLog(@"Assigning score: %d",self.audience_score);
        }
        if ( [ratingDict objectForKey:@"critics_score"] != nil) {
            self.critics_score = [[ratingDict objectForKey:@"critics_score"] intValue];
        }
        
        NSDictionary* posterDict = [dictionary objectForKey:@"posters"];
        self.thumbnails_link = [posterDict objectForKey:@"thumbnail"];
        self.synopsis = [dictionary objectForKey:@"synopsis"];
        self.thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: self.thumbnails_link]]];
    }
    return self;
}

-(id)initWithCustomDict:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        //        NSLog(dictionary.description);
        self.title = [dictionary objectForKey:@"title"];
        self.ID =[dictionary objectForKey:@"id"];
        self.year = [[dictionary objectForKey:@"year"] intValue];
        self.rating =[dictionary objectForKey:@"mpaa_rating"];
        self.runtime = [[dictionary objectForKey:@"runtime"] intValue];
        
        
        if ( [dictionary objectForKey:@"theater_release_date"] != nil) {
            self.theater_release_date = [dictionary
                                         objectForKey:@"theater_release_date"];
        }
        if ( [dictionary objectForKey:@"audience_score"] != nil) {
            self.audience_score = [[dictionary objectForKey:@"audience_score"] intValue];
            //            NSLog(@"Assigning score: %d",self.audience_score);
        }
        if ( [dictionary objectForKey:@"critics_score"] != nil) {
            self.critics_score = [[dictionary objectForKey:@"critics_score"] intValue];
        }
        self.thumbnails_link = [dictionary objectForKey:@"thumbnail"];
        self.synopsis = [dictionary objectForKey:@"synopsis"];
        NSData *imgData = [dictionary objectForKey:@"thumbnail_img"];
        if (imgData != nil) {
            self.thumbnail = [UIImage imageWithData:imgData];
        }

    }
    return self;
}

@end
