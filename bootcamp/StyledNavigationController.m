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
    self.extraImgView.backgroundColor = [UIColor clearColor];
    self.extraImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hamburgerTapped:)];
    [self.extraImgView addGestureRecognizer:tap];
    
    [self.navigationBar addSubview:self.extraImgView];

    //    self.view.backgroundColor = [UIColor colorWithRed:51/255 green:48/255 blue:39/255 alpha:1];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)hamburgerTapped:(UITapGestureRecognizer *)tap{
    NSLog(@"Hamburger Tapped!");
    [self.delegate hamburgerClicked];
}
- (void)addImgToNavBar:(UIImage *)image{
    [self.extraImgView setImage:image];
    NSLog(@"Added extra img");
}

- (void)removeImg{
    [self.extraImgView setImage:nil];
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
