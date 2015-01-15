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
#import "APIController.h"
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

- (void)addMovieToArray:(Movie *)newMovie {
    [self.arrayOfMovies addObject:newMovie];
    if (![APIController checkIfMovieExistsByID:newMovie.ID]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObject *movieToBeAdded;
        movieToBeAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
        [movieToBeAdded setValue: newMovie.title forKey:@"title"];
        [movieToBeAdded setValue: newMovie.ID forKey:@"id"];
        [movieToBeAdded setValue: [NSNumber numberWithInteger: newMovie.year ] forKey:@"year"];
        [movieToBeAdded setValue: newMovie.rating forKey:@"rating"];
        [movieToBeAdded setValue: [NSNumber numberWithInteger: newMovie.runtime ]  forKey:@"runtime"];
        [movieToBeAdded setValue: newMovie.theater_release_date forKey:@"theater_release_date"];
        [movieToBeAdded setValue: newMovie.dvd_release_date forKey:@"dvd_release_date"];
        [movieToBeAdded setValue: [NSNumber numberWithInteger: newMovie.audience_score ]  forKey:@"audience_score"];
        [movieToBeAdded setValue: [NSNumber numberWithInteger: newMovie.critics_score ]  forKey:@"critics_score"];
        [movieToBeAdded setValue: newMovie.thumbnails_link forKey:@"thumbnail_link"];
        //    NSLog(@"Thumbnail URL: %@",newMovie.thumbnails_link);
        UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: newMovie.thumbnails_link]]];
        NSData *imageData = UIImageJPEGRepresentation(thumbnailImage, 0.0);
        [movieToBeAdded setValue:imageData forKey:@"thumbnail_img"];
        [movieToBeAdded setValue: newMovie.synopsis forKey:@"synopsis"];
        //    NSLog(@"Synopsis: %@", newMovie.synopsis);
        NSError *error;
        [context save:&error];
    }else{
//        NSLog(@"Movie found, not saved!");
    }
}

- (NSArray *)getMovieArray{
    return self.arrayOfMovies;
}

-(UIImage*)getImageFromManagedObject:(NSManagedObject*)myObject
{
    NSURL *URL = [NSURL URLWithString:[myObject valueForKey:@"thumbnail_link"]];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    return [UIImage imageWithData:data];
}
@end
