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
#import "APIController.h"
#import "SessionVars.h"
#import "MovieDetailsController.h"
#import "AppDelegate.h"
#import "StyledNavigationController.h"
@interface ViewController ()
@property (strong, nonatomic) NSArray *moviesArray;
@property(strong, nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, assign) CGFloat lastSVContentOffset;
@property (nonatomic) NSInteger selectedMovieNum;
@end
typedef enum ScrollViewDirection{
    ScrollViewDirectionUp,
    ScrollViewDirectionDown
}ScrollViewDirection;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view bringSubviewToFront:self.spinner];
    [self.spinner startAnimating];
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(self.sessionQueue, ^{
        SessionVars *sessionVars = [SessionVars sharedInstance];
        [APIController getMovieDataWithCurrentStackNumber:1 andCompletionHandler:^(NSArray *movieDicts) {
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
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: movie.thumbnails_link]]];
    cell.thumbnail_img.image = image;
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
    if (self.lastSVContentOffset > verticalOffset)
        direction = ScrollViewDirectionUp;
    else{
        direction = ScrollViewDirectionDown;
    }
    self.lastSVContentOffset = verticalOffset;
    //
    //    if (([verticalOffset % 640] - ) && scrollView && direction == ScrollViewDirectionDown) {
    //        APIController getMovieDataWithCurrentStackNumber:[verticalOffset intValue] / 640 andCompletionHandler:<#^(NSArray *)completionBlock#>
    //    }
}


@end
