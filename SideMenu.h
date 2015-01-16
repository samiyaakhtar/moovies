//
//  SideMenu.h
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuCell.h"
@protocol SideMenuDelegate
//- (void)sideMenuDidOpen;
//- (void)sideMenuDidClose;
- (void)sideMenuButtonClicked;
@end
@interface SideMenu : UIView<UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) id delegate;
@property(nonatomic) NSInteger selectedIndex;
- (id)initWithFrame:(CGRect)frame andArrayOfDicts:(NSArray *)array;
- (void) highlightCellAtIndexPath:(NSIndexPath *)indexPath;
@end
