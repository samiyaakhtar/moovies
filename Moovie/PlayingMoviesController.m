//
//  PlayingMoviesController.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "PlayingMoviesController.h"
#import "SessionVars.h"
#import "APIController.h"
#import "Movie.h"
@interface PlayingMoviesController()
@property(strong, nonatomic) dispatch_queue_t sessionQueue;
@property(strong, nonatomic) UIScrollView *scrollview;
@end

@implementation PlayingMoviesController
-(void)viewDidLoad{
    NSLog(@"PlayingMoviesController view did load");
    [super viewDidLoad];
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *banner = [[UIView alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 80)];
    banner.layer.masksToBounds = NO;
    banner.backgroundColor = [UIColor colorWithRed:51/255 green:48/255 blue:39/255 alpha:1];
    banner.layer.shadowOffset = CGSizeMake(0, 0);
    banner.layer.shadowRadius = 7.0;
    banner.layer.shadowOpacity = 0.7;
    banner.layer.shadowColor = [UIColor colorWithRed:51/255 green:48/255 blue:39/255 alpha:1].CGColor;
    banner.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(banner.bounds.origin.x - 4.0, banner.bounds.origin.y - 3.0, banner.bounds.size.width + 8.0, banner.bounds.size.height + 5.0)].CGPath;
    [self.view addSubview:banner];
    
    UILabel *bannerLabel = [[UILabel alloc]initWithFrame: CGRectMake(60, 20, self.view.frame.size.width - 120, 60)];
    bannerLabel.text = @"Moovies.";
    bannerLabel.textColor = [UIColor whiteColor];
    bannerLabel.font = [UIFont fontWithName: @"AppleSDGothicNeo-Light" size:30];
    bannerLabel.textAlignment = NSTextAlignmentCenter;
    [banner addSubview:bannerLabel];
    [self.view addSubview:banner];
    
    
    self.scrollview = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.delegate = self;
    self.scrollview.scrollEnabled = YES;
    self.scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollview];

    dispatch_async(self.sessionQueue, ^{
        SessionVars *sessionVars = [SessionVars sharedInstance];
        [APIController getMovieDataWithCompletionHandler:^(NSArray *movieDicts) {
            for (NSDictionary *movieDict in movieDicts) {
                NSLog(@"%@",movieDict.description);
                Movie *movie = [[Movie alloc]initWithDictionary:movieDict];
                [sessionVars addMovieToArray:movie];
            }
            [self populateScrollView ];
        }];
    });
    
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"View did appear");
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)populateScrollView{
    
}
@end
