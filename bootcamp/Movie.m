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
        NSLog(@"ID: %@",self.ID);
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
    }
    return self;
}


@end
