//
//  StyledNavigationController.m
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "StyledNavigationController.h"

@interface StyledNavigationController ()
@property (strong, nonatomic) UIImageView *extraImgView;

@end

@implementation StyledNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extraImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    UIImage *burger = [UIImage imageNamed:@"burger_icon.png"];
    self.extraImgView.image = burger;
    self.extraImgView.backgroundColor = [UIColor clearColor];
    self.extraImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hamburgerTapped:)];
    [self.extraImgView addGestureRecognizer:tap];

    [self.navigationBar addSubview:self.extraImgView];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(90, 25, self.view.frame.size.width - 120, 30)];
    [self.view addSubview:self.searchBar];
    self.searchBar.alpha = 0;
    //    self.view.backgroundColor = [UIColor colorWithRed:51/255 green:48/255 blue:39/255 alpha:1];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)hamburgerTapped:(UITapGestureRecognizer *)tap{
    NSLog(@"Hamburger Tapped!");
    [self.delegate hamburgerClicked];
}
- (void)addImg{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.extraImgView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeImg{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.extraImgView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)openSearchBar{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.searchBar.alpha = 1;
        self.searchBar.transform = CGAffineTransformMakeTranslation(-30, 0);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(searchBarDidOpen)]) {
            [self.delegate searchBarDidOpen];
        }
    }];
    
}

- (void)closeSearchBar{
    [self.searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.searchBar.alpha = 0;
        self.searchBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(searchBarDidClose)]) {
            [self.delegate searchBarDidClose];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
