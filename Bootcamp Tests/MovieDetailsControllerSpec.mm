#import <XCTest/XCTest.h>
#import <Cedar-iOS/Cedar-iOS.h>
#import "MovieDetailsController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MovieDetailsControllerSpec)

describe(@"MovieDetailsController", ^{
    __block MovieDetailsController *moviepage;
    
    beforeEach(^{
        moviepage = [[MovieDetailsController alloc]init];
    });
    
    describe(@"moviepage scrollview", ^{
       it(@"should be the subview of moviepage", ^{
//           moviepage.scrollView should be_instance_of(UIScrollView.class);
       });
    });
});

SPEC_END
