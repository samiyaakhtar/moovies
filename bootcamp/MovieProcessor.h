//
//  MovieProcessor.h
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
@interface MovieProcessor : NSObject
+ (void)saveMovie:(Movie *)movieToBeSaved;
+ (BOOL)checkIfMovieExistsByID:(NSString *)ID;
+ (Movie *)getMovieByID:(NSString *)ID;
+ (NSMutableArray *)searchMovieByNameLocally:(NSString *)name;
+ (void)getMovieDataWithCurrentStackNumber:(int)stackNum andCompletionHandler:(void (^)(NSArray *))completionBlock;
+ (void)searchMovieOnlineWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSArray *))handler;
@end
