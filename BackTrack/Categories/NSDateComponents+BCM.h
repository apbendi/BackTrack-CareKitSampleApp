#import <CareKit/CareKit.h>

@interface NSDateComponents (BCM)

+ (NSDateComponents *_Nonnull)weekAgoComponents;
+ (NSDateComponents *_Nonnull)tomorrowComponents;
+ (NSDateComponents *_Nonnull)todayComponents;

@end
