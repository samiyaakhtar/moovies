//
//  MovieDetailsController.h
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"


@interface MovieDetailsController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *critics_score_label;

@property (weak, nonatomic) IBOutlet UILabel *aud_score_label;

@property (weak, nonatomic) IBOutlet UILabel *mpaa_label;

@property (weak, nonatomic) IBOutlet UILabel *cast_label;

@property (weak, nonatomic) IBOutlet UILabel *synopsis_label;


@property (weak, nonatomic) id delegate;

- (void)configureWithMovie:(Movie *)movie;

@end

@protocol MovieDetailsControllerDelegate
//-(void)populateFields:(MovieDetailsController *)controller;
@end