//
//  ViewController.m
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//
#import "SideMenu.h"
#import "ViewController.h"
#import "CustomCell.h"
#import "Movie.h"
#import "MovieProcessor.h"
#import "SessionVars.h"
#import "MovieDetailsController.h"
#import "AppDelegate.h"
#import "StyledNavigationController.h"
@interface ViewController ()
@property (strong, nonatomic) NSArray *moviesArray;
@property (nonatomic, assign) CGFloat lastSVContentOffset;
@property (nonatomic) NSInteger selectedMovieNum;
@property (nonatomic) int stacksLoaded;
@property (strong, nonatomic) SideMenu *sideMenu;
@property (strong, nonatomic) UIImageView *extraImgView;
@property (readwrite, nonatomic) BOOL sideMenuIsOpen;
@property (strong, nonatomic) UIView *transparentView;
@property (strong, nonatomic) StyledNavigationController *navbar;
@property (nonatomic, readwrite) BOOL searchBarIsOpen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;
@property (strong, nonatomic) NSMutableArray *localResults;
@property (strong, nonatomic) NSMutableArray *onlineResults;
@property (strong, nonatomic) NSTimer *searchTimer;

@end
typedef enum ScrollViewDirection{
    ScrollViewDirectionUp,
    ScrollViewDirectionDown
}ScrollViewDirection;
@implementation ViewController
- (void)hamburgerClicked{
    [self toggleSideMenu];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navbar = (StyledNavigationController *)self.navigationController;
    self.navbar.delegate = self;
    self.navbar.searchBar.delegate = self;
    self.sideMenuIsOpen = NO;
    self.stacksLoaded = 1;
    self.searchBarIsOpen = NO;
    self.localResults = [NSMutableArray array];
    self.onlineResults = [NSMutableArray array];
    [self.view bringSubviewToFront:self.spinner];
    [self.spinner startAnimating];
    [self.searchResultsView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self loadStack:self.stacksLoaded];
    UIImage *playingNowImage = [UIImage imageNamed:@"playing_now.png"];
    NSDictionary *playingNowDict = @{@"action":@"Playing Now.",@"image":playingNowImage};
    UIImage *boxOfficeImg = [UIImage imageNamed:@"box_office.png"];
    NSDictionary *boxOfficeDict = @{@"action":@"Box Office.",@"image":boxOfficeImg};
    UIImage *comingUpImg = [UIImage imageNamed:@"coming_up.png"];
    NSDictionary *comingUpDict = @{@"action":@"Coming Up.",@"image":comingUpImg};
    NSArray *actionDicts = @[playingNowDict, comingUpDict, boxOfficeDict];
    self.sideMenu = [[SideMenu alloc]initWithFrame:CGRectMake(-225, 60, 225, self.view.frame.size.height - 30) andArrayOfDicts:actionDicts];
    [self.view addSubview: self.sideMenu];
    self.transparentView = [[UIView alloc]initWithFrame:CGRectMake(225, 60, self.view.frame.size.width * 0.4, self.view.frame.size.height - 30)];
    self.transparentView.backgroundColor = [UIColor clearColor];
    self.transparentView.userInteractionEnabled = NO;
    UITapGestureRecognizer *closeMenuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleSideMenu)];
    [self.transparentView addGestureRecognizer:closeMenuTap];
    [self.view addSubview:self.transparentView];
    self.searchViewHeightConstraint.constant = 0;
    self.searchBarButton.target = self;
    self.searchBarButton.action = @selector(toggleSearchBar);
}

- (void)openSearchView{
    [self.view layoutIfNeeded];
    self.searchViewHeightConstraint.constant = self.view.frame.size.height - 64;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.navbar.searchBar becomeFirstResponder];
    }];
    
}

- (void)closeSearchView{
    [self.view layoutIfNeeded];
    
    self.searchViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)toggleSearchBar{
    if (self.searchBarIsOpen) {
        [self.navbar closeSearchBar];
    }else{
        [self.navbar openSearchBar];
    }
}


- (void)searchBarDidOpen{
    self.searchBarIsOpen = YES;
    [self openSearchView];
}

- (void)searchBarDidClose{
    self.searchBarIsOpen = NO;
    [self closeSearchView];
}

- (void)toggleSideMenu{
    if (self.sideMenuIsOpen) {
        NSLog(@"Closing menu");
        [self.view bringSubviewToFront:self.sideMenu];
        [self closeMenu];
    }
    else{
        NSLog(@"opening menu");
        [self.view bringSubviewToFront:self.sideMenu];
        [self openMenu];
    }
}


- (void)openMenu{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(self.sideMenu.frame.size.width, 0);
                self.searchResultsView.transform = CGAffineTransformMakeTranslation(self.sideMenu.frame.size.width, 0);
        self.sideMenu.transform = CGAffineTransformMakeTranslation(self.sideMenu.frame.size.width, 0);
    } completion:^(BOOL finished) {
        self.sideMenuIsOpen = YES;
        self.transparentView.userInteractionEnabled = YES;
    }];
    
}

- (void)closeMenu{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
                self.searchResultsView.transform = CGAffineTransformIdentity;
        self.sideMenu.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.sideMenuIsOpen = NO;
        self.transparentView.userInteractionEnabled = NO;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    [self.navbar addImg];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navbar removeImg];
    [self.navbar closeSearchBar];
}

- (void)loadStack:(int)number{
    
    SessionVars *sessionVars = [SessionVars sharedInstance];
    [MovieProcessor getMovieDataWithCurrentStackNumber:number + 1 andCompletionHandler:^(NSArray *movieDicts) {
        for (NSDictionary *movieDict in movieDicts) {
            Movie *movie = [[Movie alloc]initWithDictionary:movieDict];
            [sessionVars addMovieToArray:movie];
        }
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.spinner.alpha = 0;
        } completion:^(BOOL finished) {
            self.moviesArray = [sessionVars getMovieArray];
            [self.spinner stopAnimating];
            [self.tableView reloadData];
            NSLog(@"SV content size updated: (%f, %f)", self.tableView.contentSize.width,self.tableView.contentSize.height);
        }];
    }];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"View did appear");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"ShowMovieDetails"]) {
        NSDictionary *dict = sender;
        MovieDetailsController *movieDetailsController = segue.destinationViewController;
        Movie *movie;
        UITableView *tableview = [dict objectForKey:@"tableView"];
        if (tableview == self.tableView) {
            movie = [self.moviesArray objectAtIndex:[[dict objectForKey:@"row"] integerValue]];
        }
        else{
            NSInteger section = [[dict objectForKey:@"section"] integerValue];
            if (section == 0) {
                movie = [self.localResults objectAtIndex:[[dict objectForKey:@"row"] integerValue]];
            }
            else{
                movie = [self.onlineResults objectAtIndex:[[dict objectForKey:@"row"] integerValue]];
            }
        }
        [movieDetailsController configureWithMovie:movie];
    }
}

#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView){
        return self.moviesArray.count;
    }
    else{
        if (section==0)
        {
            return [self.localResults count];
        }
        else{
            return [self.onlineResults count];
        }
    }
}

- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *cellID = @"cellID";
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        Movie *movie = [self.moviesArray objectAtIndex:indexPath.row];
        cell.title.text = movie.title;
        cell.runtime.text = [NSString stringWithFormat:@"%d mins",movie.runtime];
        cell.rating.text = [NSString stringWithFormat:@"%d%%",movie.audience_score];
        cell.thumbnail_img.image = movie.thumbnail;
        return cell;
    }
    else if(tableView == self.searchResultsView){
        static NSString *cellID = @"cellID";
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        Movie *movie;
        NSLog(self.localResults.description);
        if (indexPath.section == 0) {
            movie = [self.localResults objectAtIndex:indexPath.row];
        }
        else{
            movie = [self.onlineResults objectAtIndex:indexPath.row];
        }
        cell.title.text = movie.title;
        cell.runtime.text = [NSString stringWithFormat:@"%d mins",movie.runtime];
        cell.rating.text = [NSString stringWithFormat:@"%d%%",movie.audience_score];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: movie.thumbnails_link]]];
        cell.thumbnail_img.image = image;
        if (movie.thumbnail != nil){
            cell.thumbnail_img.image = movie.thumbnail;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *section = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSString *row = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    NSDictionary *dict = @{@"tableView":tableView,@"section":section,@"row":row};
    [self performSegueWithIdentifier:@"ShowMovieDetails" sender:dict];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 1;
    }
    else{
        return 2;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchResultsView) {
        if(section == 0)
            return @"Cached results";
        else
            return @"Online results";
    }
    return nil;
}



#pragma mark UIScrollView
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    ScrollViewDirection direction;
    CGFloat verticalOffset = scrollView.contentOffset.y;
    verticalOffset += 64;
    if (self.lastSVContentOffset > verticalOffset)
        direction = ScrollViewDirectionUp;
    else{
        direction = ScrollViewDirectionDown;
    }
    self.lastSVContentOffset = verticalOffset;
    
    //    NSLog(@" vertical offset = %f", verticalOffset);
    CGFloat threshold = 500;
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
        threshold = 200;
    }
    if (scrollView == self.tableView) {
        if (((int)verticalOffset % 1200 > threshold) && scrollView && direction == ScrollViewDirectionDown && ((int)verticalOffset / 1200 == self.stacksLoaded - 1)) {
            self.stacksLoaded++;
            NSLog(@"loading stack #%d", self.stacksLoaded);
            [self loadStack:self.stacksLoaded];
        }
    }
    
}


#pragma mark UISearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"did begin editing");
    [self.searchTimer invalidate];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchTimer invalidate];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(search) userInfo:nil repeats:NO];
}

- (void)search{
    [self.localResults removeAllObjects];
    [self.onlineResults removeAllObjects];
    [self.searchResultsView reloadData];
    NSString *searchString = self.navbar.searchBar.text;
    if (![searchString isEqualToString:@""]) {
        [self.searchTimer invalidate];
        NSLog(@"Searching with keyword: %@", searchString);
        NSLog(@"LOCAL: ");
        //        dispatch_async(self.queue, ^{
        NSMutableArray *localResults = [MovieProcessor searchMovieByNameLocally:searchString];
        if ([localResults count] > 0) {
            [self.localResults addObjectsFromArray:localResults];
            self.localResults = localResults;
            NSLog(@"local search results count: %lu",(unsigned long)[self.localResults count]);
            //                dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResultsView reloadData];
            //                });
            
        }
        
        [MovieProcessor searchMovieOnlineWithKeyword:searchString completionHandler:^(NSArray *movieDicts) {
            for (NSDictionary *movieDict in movieDicts) {
                Movie *movie = [[Movie alloc]initWithDictionary:movieDict];
                [self.onlineResults addObject:movie];
            }
            NSLog(@"online search results count: %lu",(unsigned long)[self.onlineResults count]);
            //                dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResultsView reloadData];
            //                });
            
        }];
        //        });
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.navbar.searchBar resignFirstResponder];
    [self search];
}



@end
