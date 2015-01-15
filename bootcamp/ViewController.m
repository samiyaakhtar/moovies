//
//  ViewController.m
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//

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
@property(strong, nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, assign) CGFloat lastSVContentOffset;
@property (nonatomic) NSInteger selectedMovieNum;
@property (nonatomic) int stacksLoaded;
@end
typedef enum ScrollViewDirection{
    ScrollViewDirectionUp,
    ScrollViewDirectionDown
}ScrollViewDirection;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stacksLoaded = 1;
    [self.view bringSubviewToFront:self.spinner];
    [self.spinner startAnimating];
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self loadStack:self.stacksLoaded];
}

- (void)loadStack:(int)number{
    dispatch_async(self.sessionQueue, ^{
        SessionVars *sessionVars = [SessionVars sharedInstance];
        [MovieProcessor getMovieDataWithCurrentStackNumber:number + 1 andCompletionHandler:^(NSArray *movieDicts) {
            for (NSDictionary *movieDict in movieDicts) {
                //                NSLog(@"%@",movieDict.description);
                Movie *movie = [[Movie alloc]initWithDictionary:movieDict];
                [sessionVars addMovieToArray:movie];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.spinner.alpha = 0;
                } completion:^(BOOL finished) {
                    self.moviesArray = [sessionVars getMovieArray];
                    [self.spinner stopAnimating];
                    [self.tableView reloadData];
                    NSLog(@"SV content size updated: (%f, %f)", self.tableView.contentSize.width,self.tableView.contentSize.height);
                }];
                
            });
        }];
        
    });
    
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
