//
//  APIController.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "APIController.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
@interface APIController()

@end
@implementation APIController
+(void)getMovieDataWithCurrentStackNumber:(int)stackNum menuSelectionIndex:(NSInteger)menuSelectionIndex andCompletionHandler:(void (^)(NSArray *))completionBlock{
    __block NSMutableArray *dictArray;
    NSLog(@"Fetching movie data");
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://api.rottentomatoes.com"]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"page_limit":@"15",
                             @"page":[NSString stringWithFormat:@"%d", stackNum],
                             @"country":@"ca",
                             @"apikey":@"eagsdfzp8g3f4hfhcbjj337s"};
    
    NSString* URL = [NSString alloc];
    if(menuSelectionIndex == 0) {
        URL = @"/api/public/v1.0/lists/movies/in_theaters.json";
    }
    else if(menuSelectionIndex == 1) {
        URL = @"/api/public/v1.0/lists/movies/upcoming.json";
    }
    else {
        URL = @"/api/public/v1.0/lists/movies/box_office.json";
        
    }
    
    [manager GET:URL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        dictArray = [dict objectForKey:@"movies"];
        completionBlock(dictArray);
        NSLog(@" got dictionary with count %lu", [dictArray count]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+(void)searchMovieOnlineWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSArray *))handler{
    __block NSMutableArray *dictArray;
    NSLog(@"Fetching movie data");
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://api.rottentomatoes.com"]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"page_limit":@"15",
                             @"page":@"1",
                             @"q":keyword,
                             @"apikey":@"eagsdfzp8g3f4hfhcbjj337s"};
    [manager GET:@"/api/public/v1.0/movies.json" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject;
        dictArray = [dict objectForKey:@"movies"];
        //        NSLog(@"online results count: %d", [dictArray count]);
        handler(dictArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
