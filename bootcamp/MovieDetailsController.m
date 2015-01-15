//
//  MovieDetailsController.m
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "MovieDetailsController.h"

@interface MovieDetailsController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synopsisHeightConstraint;

@property (nonatomic, strong) Movie *movie;


@end

@implementation MovieDetailsController

- (void)configureWithMovie:(Movie *)movie {
    self.movie = movie;
}

- (void)viewDidLoad {
    NSLog(@"ViewDidLoad");
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.synopsis_label.lineBreakMode = NSLineBreakByWordWrapping;
    self.cast_label.lineBreakMode = NSLineBreakByWordWrapping;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self populateDetails];
    // Do any additional setup after loading the view.
    
}

- (void)populateDetails {
    NSLog(@"Populating Detail Area");
    
    self.titleLabel.text = self.movie.title;
    self.runtimeLabel.text = [NSString stringWithFormat:@"%d mins", self.movie.runtime ];
    self.critics_score_label.text = [NSString stringWithFormat:@"%d%%", self.movie.critics_score ];
    self.aud_score_label.text = [NSString stringWithFormat:@"%d%%", self.movie.audience_score ];
    self.mpaa_label.text = self.movie.rating;
    self.synopsis_label.text = self.movie.synopsis;
    self.synopsisHeightConstraint.constant = [self heightForSynopsis:self.movie.synopsis];
    self.img_view.image = self.movie.thumbnail;
    //Get casts
}

- (CGFloat)heightForSynopsis:(NSString *)synopsis {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:19.0f]};
    
    CGRect boundingRect = [synopsis boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.synopsis_label.frame), 4000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
    
    return boundingRect.size.height;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(0, scrollView.contentOffset.y)];
}

@end
