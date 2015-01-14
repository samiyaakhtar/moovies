//
//  SessionVars.h
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
@interface SessionVars : NSObject

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedInstance;
- (void)addMovieToArray:(Movie *)movie;
@end
