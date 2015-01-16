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
@property (strong, nonatomic) NSMutableArray *playingNowMoviesArray;
@property (strong, nonatomic) NSMutableArray *comingUpMoviesArray;
@property (strong, nonatomic) NSMutableArray *boxOfficeMoviesArray;
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
        self.playingNowMoviesArray = [[NSMutableArray alloc]init];
        self.comingUpMoviesArray = [[NSMutableArray alloc]init];
        self.boxOfficeMoviesArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSInteger)movieCount:(NSInteger)option{
    switch (option) {
        case 0:
            return [self.playingNowMoviesArray count];
        case 1:
            return [self.comingUpMoviesArray count];
        case 2:
            return [self.boxOfficeMoviesArray count];
    }
    
    return 0;
    
}

- (void)addMovie:(Movie *)newMovie toArrayWithOption:(NSInteger)option{
    switch (option) {
        case 0:
            [self.playingNowMoviesArray addObject:newMovie];
            break;
        case 1:
            [self.comingUpMoviesArray addObject:newMovie];
            break;
        case 2:
            [self.boxOfficeMoviesArray addObject:newMovie];
            break;
    }
    
    if (![MovieProcessor checkIfMovieExistsByID:newMovie.ID]) {
        [MovieProcessor saveMovie:newMovie];
    }else{
        NSLog(@"No need to save movie: %@",newMovie.title);
    }
    
}

- (NSMutableArray *)getMovieArray:(NSInteger)option{
    switch (option) {
        case 0:
            NSLog(@"returning PNMArray with count %ld for option %ld", self.playingNowMoviesArray.count, (long)option);
            return self.playingNowMoviesArray;
        case 1:
            NSLog(@"returning CUMArray with count %ld for option %ld", self.comingUpMoviesArray.count, (long)option);
            return self.comingUpMoviesArray;
        case 2:
            NSLog(@"returning box office array with count %ld for option %ld", self.comingUpMoviesArray.count, (long)option);
            return self.boxOfficeMoviesArray;
        default:
            return nil;
    }
    
}

-(UIImage*)getImageFromManagedObject:(NSManagedObject*)myObject
{
    NSURL *URL = [NSURL URLWithString:[myObject valueForKey:@"thumbnail_link"]];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    return [UIImage imageWithData:data];
}
@end
