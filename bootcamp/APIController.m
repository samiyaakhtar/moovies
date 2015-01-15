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
+(void)getMovieDataWithCurrentStackNumber:(int)stackNum andCompletionHandler:(void (^)(NSArray *))completionBlock{
    __block NSMutableArray *dictArray;
    NSLog(@"Fetching movie data");
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://api.rottentomatoes.com"]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"page_limit":@"15",
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

+ (BOOL)checkIfMovieExistsByID:(NSString *)ID{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(id = %@)", ID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjs = [context executeFetchRequest:request
                                                  error:&error];
    if ([fetchedObjs count] == 0)
    {
        NSLog(@"No matches");
        return NO;
    }
    
    return YES;
    
}

+(Movie *)getMovieByID:(NSString *)ID{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(id = %@)", ID];
    [request setPredicate:predicate];
    NSManagedObject *matchedObj = nil;
    NSError *error;
    NSArray *fetchedObjs = [context executeFetchRequest:request
                                                  error:&error];
    if ([fetchedObjs count] == 0)
    {
        NSLog(@"No matches");
        return nil;
    }
    else
    {
        matchedObj = [fetchedObjs objectAtIndex:0];
        NSArray* fetchedObjKeys = @[@"year",@"title",@"thumbnail_link",@"thumbnail_img",@"theater_release_date",@"synopsis",@"runtime",@"rating",@"id",@"dvd_release_date",@"critics_score",@"audience_score"];
        NSDictionary *dict = [matchedObj committedValuesForKeys:fetchedObjKeys];
        NSLog(@"%@",dict.description);
        Movie *movie = [[Movie alloc]initWithDictionary:dict];
        return movie;
    }
    
}
@end
