//
//  MovieSearchViewController.m
//  bootcamp
//
//  Created by DX209 on 2015-01-15.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "MovieSearchViewController.h"
#import "CustomCell.h"
#import "Movie.h"
#import "MovieProcessor.h"
#import "SessionVars.h"
#import "MovieDetailsController.h"

@interface MovieSearchViewController ()
@property (strong, nonatomic) NSMutableArray *localResults;
@property (strong, nonatomic) NSMutableArray *onlineResults;
@property (strong, nonatomic) NSTimer *searchTimer;
@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation MovieSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchResultsView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
    self.queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    self.searchResultsView.delegate = self;
    self.searchResultsView.dataSource = self;
    self.localResults = [NSMutableArray array];
    self.onlineResults = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
    [self.searchBar resignFirstResponder];
}

#pragma mark UISearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"did begin editing");
    [self.searchTimer invalidate];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchTimer invalidate];
//    [self.localResults removeAllObjects];
//    [self.onlineResults removeAllObjects];
//    NSLog(@"editing did end, removing everything");
//    [self.searchResultsView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(search) userInfo:nil repeats:NO];
}

- (void)search{
    [self.localResults removeAllObjects];
    [self.onlineResults removeAllObjects];
    [self.searchResultsView reloadData];
    NSString *searchString = self.searchBar.text;
    if (![searchString isEqualToString:@""]) {
        [self.searchTimer invalidate];
        NSLog(@"Searching with keyword: %@", searchString);
        NSLog(@"LOCAL: ");
//        dispatch_async(self.queue, ^{
            NSMutableArray *localResults = [MovieProcessor searchMovieByNameLocally:searchString];
            if ([localResults count] > 0) {
                [self.localResults addObjectsFromArray:localResults];
                self.localResults = localResults;
                NSLog(@"search results count: %lu",(unsigned long)[self.localResults count]);
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchResultsView reloadData];
//                });
                
            }
            
            [MovieProcessor searchMovieOnlineWithKeyword:searchString completionHandler:^(NSArray *movieDicts) {
                for (NSDictionary *movieDict in movieDicts) {
                    Movie *movie = [[Movie alloc]initWithDictionary:movieDict];
                    [self.onlineResults addObject:movie];
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchResultsView reloadData];
//                });
                
            }];
//        });
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self search];
}

#pragma mark UITableView
- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Loading cell #%d", indexPath.row);
    static NSString *cellID = @"cellID";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    Movie *movie;
    if (indexPath.section == 0) {
        movie = [self.localResults objectAtIndex:indexPath.row];
    }
    else{
        movie = [self.onlineResults objectAtIndex:indexPath.row];
    }
    
    cell.title.text = movie.title;
    //    cell.thumbnail_img
    cell.runtime.text = [NSString stringWithFormat:@"%d mins",movie.runtime];
    //        NSLog(@"Audience Score: %d",movie.audience_score);
    cell.rating.text = [NSString stringWithFormat:@"%d%%",movie.audience_score];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: movie.thumbnails_link]]];
    cell.thumbnail_img.image = image;
    if (movie.thumbnail != nil){
        cell.thumbnail_img.image = movie.thumbnail;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath{
    //    NSLog(@"returning 80");
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showMovieDetailsFromSearch" sender:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return [self.localResults count];
    }
    else{
        return [self.onlineResults count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Cached results";
    else
        return @"Online results";
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"showMovieDetailsFromSearch"]) {
        
        NSIndexPath *indexPath = sender;
        MovieDetailsController *movieDetailsController = segue.destinationViewController;
        
        Movie *movie;
        if (indexPath.section == 0) {
            movie = [self.localResults objectAtIndex:indexPath.row];
        }
        else{
            movie = [self.onlineResults objectAtIndex:indexPath.row];
        }
        
        [movieDetailsController configureWithMovie:movie];
    }
}

@end
