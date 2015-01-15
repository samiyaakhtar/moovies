//
//  APIController.h
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
@interface APIController : NSObject
+(void)getMovieDataWithCurrentStackNumber:(int)stackNum andCompletionHandler:(void (^)(NSArray *))completionBlock;
+(BOOL)checkIfMovieExistsByID:(NSString *)ID;
+(Movie *)getMovieByID:(NSString *)ID;
+(NSMutableArray *)searchMovieByNameLocally:(NSString *)name;
+(void)searchMovieOnlineWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSArray *))handler;
@end
