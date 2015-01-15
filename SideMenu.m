//
//  SideMenu.m
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "SideMenu.h"
#import "SideMenuCell.h"
@interface SideMenu()
@property(strong, nonatomic) UITableView *tableview;
@property(strong, nonatomic) NSArray *actions;
@end
@implementation SideMenu
- (id)initWithFrame:(CGRect)frame andArrayOfDicts:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.actions = array;
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.tableview registerNib:[UINib nibWithNibName:@"SideMenuCell" bundle:nil] forCellReuseIdentifier:@"sideCell"];
        self.tableview.backgroundColor = [UIColor colorWithRed:51/255 green:48/255 blue:39/255 alpha:1];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableview];
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        [self.tableview reloadData];
    }
    return self;
}



#pragma mark UITableView
- (SideMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"sideCell";
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *actionDict = [self.actions objectAtIndex:indexPath.row];
    cell.action.text = [actionDict objectForKey:@"action"];
    cell.imageView.image = [actionDict objectForKey:@"image"];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.actions count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
