//
//  MovieSearchViewController.h
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieSearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *searchResultsView;

@end
