//
//  MovieProcessor.m
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "MovieProcessor.h"
#import "AppDelegate.h"
#import "APIController.h"
#import <CoreData/CoreData.h>
@implementation MovieProcessor
+(void)saveMovie:(Movie *)movieToBeSaved{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *movieToBeAdded;
    movieToBeAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
    [movieToBeAdded setValue: movieToBeSaved.title forKey:@"title"];
    [movieToBeAdded setValue: movieToBeSaved.ID forKey:@"id"];
    [movieToBeAdded setValue: [NSNumber numberWithInteger: movieToBeSaved.year ] forKey:@"year"];
    [movieToBeAdded setValue: movieToBeSaved.rating forKey:@"rating"];
    [movieToBeAdded setValue: [NSNumber numberWithInteger: movieToBeSaved.runtime ]  forKey:@"runtime"];
    [movieToBeAdded setValue: movieToBeSaved.theater_release_date forKey:@"theater_release_date"];
    [movieToBeAdded setValue: movieToBeSaved.dvd_release_date forKey:@"dvd_release_date"];
    [movieToBeAdded setValue: [NSNumber numberWithInteger: movieToBeSaved.audience_score ]  forKey:@"audience_score"];
    [movieToBeAdded setValue: [NSNumber numberWithInteger: movieToBeSaved.critics_score ]  forKey:@"critics_score"];
    [movieToBeAdded setValue: movieToBeSaved.thumbnails_link forKey:@"thumbnail_link"];
    //    NSLog(@"Thumbnail URL: %@",newMovie.thumbnails_link);
    UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: movieToBeSaved.thumbnails_link]]];
    NSData *imageData = UIImageJPEGRepresentation(thumbnailImage, 0.0);
    [movieToBeAdded setValue:imageData forKey:@"thumbnail_img"];
    [movieToBeAdded setValue: movieToBeSaved.synopsis forKey:@"synopsis"];
    //    NSLog(@"Synopsis: %@", newMovie.synopsis);
    NSError *error;
    [context save:&error];
    NSLog(@"\"%@ saved.\"", movieToBeSaved.title);
    
    
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

+ (Movie *)getMovieByID:(NSString *)ID{
    Movie *movie = nil;
    
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
    }
    else{
        NSLog(@"Found movie");
        NSManagedObject *matchedObj = [fetchedObjs objectAtIndex:0];
        NSArray* fetchedObjKeys = @[@"year",@"title",@"thumbnail_link",@"thumbnail_img",@"theater_release_date",@"synopsis",@"runtime",@"rating",@"id",@"dvd_release_date",@"critics_score",@"audience_score"];
        NSDictionary *dict = [matchedObj committedValuesForKeys:fetchedObjKeys];
//        NSLog(@"Synopsis:::::::::::\n%@",[dict objectForKey:@"synopsis"]);
        movie = [[Movie alloc]initWithDictionary:dict];
        
    }
    
    return movie;
}


+(NSMutableArray *)searchMovieByNameLocally:(NSString *)keyword{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", keyword];
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
        NSLog(@"FOUND MOVIE MATCHING %@",keyword);
        NSMutableArray *moviesArray = [NSMutableArray array];
        //        NSLog(@"Found %d entries", [fetchedObjs count]);
        for (int i = 0; i < [fetchedObjs count]; i++) {
            matchedObj = [fetchedObjs objectAtIndex:i];
            NSArray* fetchedObjKeys = @[@"year",@"title",@"thumbnail_link",@"thumbnail_img",@"theater_release_date",@"synopsis",@"runtime",@"rating",@"id",@"dvd_release_date",@"critics_score",@"audience_score"];
            NSDictionary *dict = [matchedObj committedValuesForKeys:fetchedObjKeys];
            //            NSLog(dict.description);
            //            NSLog(@"Synopsis:::::::::::\n%@",[dict objectForKey:@"synopsis"]);
            Movie *movie = [[Movie alloc]initWithCustomDict:dict];
            [moviesArray addObject:movie];
        }
        
        return moviesArray;
    }
    
}

+ (void)getMovieDataWithCurrentStackNumber:(int)stackNum menuSelectionIndex:(NSInteger)index andCompletionHandler:(void (^)(NSArray *))completionBlock{
    [APIController getMovieDataWithCurrentStackNumber:stackNum menuSelectionIndex:index andCompletionHandler:completionBlock];
}
+ (void)searchMovieOnlineWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSArray *))handler{
    [APIController searchMovieOnlineWithKeyword:keyword completionHandler:handler];
}
@end
