#import <CloudMine/CloudMine.h>
#import <CareKit/CareKit.h>

@interface BCMActivityList : CMObject

@property (nonatomic, nonnull, readonly) NSArray <OCKCarePlanActivity *> * activities;
- (_Nonnull instancetype)initWithActivities:(NSArray<OCKCarePlanActivity *> *_Nonnull)activities;

@end
