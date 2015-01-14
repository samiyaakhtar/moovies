//
//  RootController.m
//  Moovie
//
//  Created by DX209 on 2015-01-13.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "RootController.h"
#import "AppDelegate.h"
@interface RootController ()
@property (strong, nonatomic) UIViewController *activeController;
@property (nonatomic) int *numViews;
@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
        NSLog(@"RootController view did load");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initVCWithController:(UIViewController*) controller {
        NSLog(@"initVCWithController");
    if(self.numViews == 0) {
        self.activeController = controller;
        UIView* view = [[UIView alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:view];
        AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDel changeRootVC:controller];
    }
}

@end
