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
    StyledNavigationController *navbar = (StyledNavigationController *)self.navigationController;
    navbar.delegate = self;
    self.sideMenuIsOpen = NO;
    self.stacksLoaded = 1;
    [self.view bringSubviewToFront:self.spinner];
    [self.spinner startAnimating];

    [self loadStack:self.stacksLoaded];
    UIImage *playingNowImage = [UIImage imageNamed:@"playing_now.png"];
    NSDictionary *playingNowDict = @{@"action":@"Playing Now.",@"image":playingNowImage};
    UIImage *boxOfficeImg = [UIImage imageNamed:@"box_office.png"];
    NSDictionary *boxOfficeDict = @{@"action":@"Box Office.",@"image":boxOfficeImg};
    UIImage *comingUpImg = [UIImage imageNamed:@"coming_up.png"];
    NSDictionary *comingUpDict = @{@"action":@"Coming Up.",@"image":comingUpImg};
    NSArray *actionDicts = @[playingNowDict, comingUpDict, boxOfficeDict];
    self.sideMenu = [[SideMenu alloc]initWithFrame:CGRectMake(-225, 60, 225, self.view.frame.size.height - 30) andArrayOfDicts:actionDicts];
    //    self.sideMenu.delegate = self;
    [self.view addSubview: self.sideMenu];
    self.transparentView = [[UIView alloc]initWithFrame:CGRectMake(225, 60, self.view.frame.size.width * 0.4, self.view.frame.size.height - 30)];
    self.transparentView.backgroundColor = [UIColor clearColor];
    self.transparentView.userInteractionEnabled = NO;
    UITapGestureRecognizer *closeMenuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleSideMenu)];
    [self.transparentView addGestureRecognizer:closeMenuTap];
    [self.view addSubview:self.transparentView];
}
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.sideMenu.frame = CGRectMake(0 ,30, 225, self.view.frame.size.height - 30);
////                self.sideMenu.transform = CGAffineTransformMakeTranslation(self.sideMenu.frame.size.width, 0);
//}
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
                            self.sideMenu.transform = CGAffineTransformMakeTranslation(self.sideMenu.frame.size.width, 0);
    } completion:^(BOOL finished) {
        self.sideMenuIsOpen = YES;
        self.transparentView.userInteractionEnabled = YES;
    }];
    
}

- (void)closeMenu{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
                self.sideMenu.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.sideMenuIsOpen = NO;
        self.transparentView.userInteractionEnabled = NO;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        NSLog(@"View will appear");
    StyledNavigationController *navbar = (StyledNavigationController *)self.navigationController;
    [navbar addImg];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    StyledNavigationController *navbar = (StyledNavigationController *)self.navigationController;
    [navbar removeImg];
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
        NSIndexPath *indexPath = sender;
        MovieDetailsController *movieDetailsController = segue.destinationViewController;
        Movie *movie = [self.moviesArray objectAtIndex:indexPath.row];
        [movieDetailsController configureWithMovie:movie];
    }
}

#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moviesArray.count;
}

- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Movie *movie = [self.moviesArray objectAtIndex:indexPath.row];
    cell.title.text = movie.title;
    //    cell.thumbnail_img
    cell.runtime.text = [NSString stringWithFormat:@"%d mins",movie.runtime];
    //    NSLog(@"Audience Score: %d",movie.audience_score);
    cell.rating.text = [NSString stringWithFormat:@"%d%%",movie.audience_score];
    cell.thumbnail_img.image = movie.thumbnail;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowMovieDetails" sender:indexPath];
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
    if (((int)verticalOffset % 1200 > 500) && scrollView && direction == ScrollViewDirectionDown && ((int)verticalOffset / 1200 == self.stacksLoaded - 1)) {
        self.stacksLoaded++;
        NSLog(@"loading stack #%d", self.stacksLoaded);
        [self loadStack:self.stacksLoaded];
    }
}


@end
