//
//  StyledNavigationController.h
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//
@protocol StyledNavigationControllerDelegate
- (void)hamburgerClicked;
@end
#import <UIKit/UIKit.h>
#import "SideMenu.h"
@interface StyledNavigationController : UINavigationController
@property(weak, nonatomic) id delegate;
- (void)addImgToNavBar:(UIImage *)image;
- (void)removeImg;
- (void)openSideMenu:(SideMenu *)sideMenu;
@end
