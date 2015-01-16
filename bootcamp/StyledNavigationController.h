//
//  StyledNavigationController.h
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//
@protocol StyledNavigationControllerDelegate
- (void)hamburgerClicked;
- (void)searchBarDidOpen;
- (void)searchBarDidClose;
@end
#import <UIKit/UIKit.h>
#import "SideMenu.h"
@interface StyledNavigationController : UINavigationController<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property(weak, nonatomic) id delegate;
- (void)addImg;
- (void)removeImg;
- (void)openSearchBar;
- (void)closeSearchBar;
@end
