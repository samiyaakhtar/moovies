#import <XCTest/XCTest.h>
      #import <Cedar-iOS/Cedar-iOS.h>
#import "APIController.h"
#import "Movie.h"
      

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ExampleSpec)

/* This is not an exhaustive list of usages.
   For more information, please visit https://github.com/pivotal/cedar */

describe(@"Specs on Bootcamp", ^{
    
    beforeEach(^{
        
    });
    
    describe(@"APIController getMovieByID", ^{
        it(@"should return an instance of Movie", ^{
            [APIController getMovieByID:@"771181360"] should be_instance_of(Movie.class);
        });
    });
    
    describe(@"APIController getMovieData", ^ {
        it(@"should return a NSArray of 15 entries", ^{
            [APIController getMovieDataWithCurrentStackNumber:1 andCompletionHandler:^(NSArray *array) {
                [array count] should equal(15);
            }];
            
        });
    });
    

});

SPEC_END
