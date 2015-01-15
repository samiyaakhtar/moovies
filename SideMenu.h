//
//  SideMenu.h
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SideMenuDelegate
- (void)sideMenuDidOpen;
- (void)sideMenuDidClose;
@end
@interface SideMenu : UIView<UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) id delegate;
- (id)initWithFrame:(CGRect)frame andArrayOfDicts:(NSArray *)array;

@end
