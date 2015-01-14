//
//  APIController.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "APIController.h"
#import <AFURLSessionManager.h>
#import <AFHTTPSessionManager.h>
@implementation APIController
+(void)getMovieDataWithCompletionHandler:(void (^)(NSMutableArray *))completionBlock{
    __block NSMutableArray *dictArray;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://api.rottentomatoes.com"]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"page_limit":@"20",
                             @"page":@"1",
                             @"country":@"ca",
                             @"apikey":@"eagsdfzp8g3f4hfhcbjj337s"};
    [manager GET:@"/api/public/v1.0/lists/movies/in_theaters.json" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        dictArray = [dict objectForKey:@"movies"];
        completionBlock(dictArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
