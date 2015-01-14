//
//  APIController.h
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIController : NSObject
+(void)getMovieDataWithCompletionHandler:(void (^)(NSMutableArray *))completionBlock;
@end
