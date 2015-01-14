//
//  SessionVars.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "SessionVars.h"
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

- (void)addMovieToArray:(Movie *)newMovie{
    [self.arrayOfMovies addObject:newMovie];
}
@end
