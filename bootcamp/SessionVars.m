//
//  SessionVars.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "SessionVars.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "MovieProcessor.h"
@interface SessionVars()
@property (strong, nonatomic) NSMutableArray *arrayOfMovies;
@end
@implementation SessionVars

+ (id)sharedInstance {
    static SessionVars *sessionVars = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionVars = [[self alloc] init];
    });
    return sessionVars;
}

- (id)init {
    if (self = [super init]) {
        self.arrayOfMovies = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (NSInteger)movieCount{
    return [self.arrayOfMovies count];
}

- (void)addMovieToArray:(Movie *)newMovie {
    [self.arrayOfMovies addObject:newMovie];
    if (![MovieProcessor checkIfMovieExistsByID:newMovie.ID]) {
        [MovieProcessor saveMovie:newMovie];
    }else{
        NSLog(@"No need to save movie: %@",newMovie.title);
    }
    
}

- (NSArray *)getMovieArray{
    return self.arrayOfMovies;
}

-(UIImage*)getImageFromManagedObject:(NSManagedObject*)myObject
{
    NSURL *URL = [NSURL URLWithString:[myObject valueForKey:@"thumbnail_link"]];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    return [UIImage imageWithData:data];
}
@end
