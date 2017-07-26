#import "BCMCareNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "UIColor+BCM.h"
#import "BCMMainThread.h"
#import "OCKCarePlanEvent+BCM.h"
#import "BCMTasks.h"

@interface BCMCareNavController () <OCKCareContentsViewControllerDelegate, OCKCareCardViewControllerDelegate, ORKTaskViewControllerDelegate>

@property (nonatomic) OCKCareCardViewController *careContentsViewController;

@end

@implementation BCMCareNavController


#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor bcmBlueColor];
    [self reloadCareViewController];
}

- (void)reloadCareViewController
{
    on_main_thread(^{
        self.careContentsViewController = [[OCKCareCardViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];
        self.careContentsViewController.navigationItem.title = NSLocalizedString(@"Care Plan", nil);
        self.careContentsViewController.delegate = self;
        self.viewControllers = @[self.careContentsViewController];
    });
}

- (BOOL)shouldEnablePullToRefreshInCareCardViewController:(OCKCareCardViewController *)viewController
{
    return YES;
}

- (void)careCardViewController:(OCKCareCardViewController *)viewController didActivatePullToRefreshControl:(UIRefreshControl *)refreshControl
{
    [NSTimer scheduledTimerWithTimeInterval:3.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        [refreshControl endRefreshing];
    }];
}

#pragma mark OCKCareContentsViewControllerDelegate

- (void)careContentsViewController:(OCKCareContentsViewController *)viewController didSelectRowWithAssessmentEvent:(OCKCarePlanEvent *)assessmentEvent
{
    NSLog(@"[BCM] Selected Assessment: %@", assessmentEvent.activity.identifier);
    
    if (![assessmentEvent isAvailable]) {
        return;
    }
    
    ORKOrderedTask *task = [BCMTasks taskForAssessmentIdentifier:assessmentEvent.activity.identifier];
    if (nil == task) {
        return;
    }
    
    ORKTaskViewController *taskViewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    taskViewController.view.tintColor = [UIColor bcmBlueColor];
    [self presentViewController:taskViewController animated:YES completion:nil];
}

#pragma mark ORKTaskViewControllerDelegate

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    if (reason != ORKTaskViewControllerFinishReasonCompleted) {
//        return;
//    }
//    
//    OCKCarePlanEvent *event = self.careContentsViewController.lastSelectedEvent;
//    ORKTaskResult *taskResult = taskViewController.result;
//    
//    NSAssert(nil != event &&
//             nil != taskResult &&
//             [event.activity.identifier isEqualToString:taskResult.identifier],
//             @"Expected care plan event and task result identifier to match. Got %@ and %@", event.activity.identifier, taskResult.identifier);
//    
//    [self completeEvent:event
//             withResult:[BCMTasks carePlanResultForTaskResult:taskResult]];   
}

#pragma mark Helpers

- (void)completeEvent:(OCKCarePlanEvent *_Nonnull)event withResult:(OCKCarePlanEventResult *_Nullable)result
{
    if (nil == result) {
        return;
    }
    
    [self.bcmTabBarController.carePlanStore updateEvent:event withResult:result state:OCKCarePlanEventStateCompleted completion:^(BOOL success, OCKCarePlanEvent * _Nullable event, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"Failed to update event store: %@", error.localizedDescription);
            return;
        }
    }];
}

@end
