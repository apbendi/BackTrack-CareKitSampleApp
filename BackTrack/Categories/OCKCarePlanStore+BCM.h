#import <CareKit/CareKit.h>

typedef void(^BCMCarePlanSaveCompletion)(NSError *_Nullable error);
typedef void(^BCMCarePlanActivityFetchCompletion)(NSArray<OCKCarePlanActivity *> *_Nullable activities, NSError *_Nullable error);

@interface OCKCarePlanStore (BCM)

- (void)bcm_saveActivtiesWithCompletion:(_Nullable BCMCarePlanSaveCompletion)block;
- (void)bcm_fetchActivitiesWithCompletion:(_Nullable BCMCarePlanActivityFetchCompletion)block;

@end