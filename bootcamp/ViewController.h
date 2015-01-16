//
//  ViewController.h
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDetailsController.h"
@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MovieDetailsControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;


@end

