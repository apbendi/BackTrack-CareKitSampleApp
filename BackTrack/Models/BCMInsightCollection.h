#import <CareKit/CareKit.h>

@class BCMInsightItem;

@interface BCMInsightCollection : NSObject

- (nonnull instancetype)initWithItems:(nonnull NSArray<BCMInsightItem *> *)items title:(nonnull NSString *)title tintColor:(nullable UIColor *)color;

@property (nonatomic, nonnull, readonly) OCKBarSeries *series;
@property (nonatomic, nonnull, readonly) NSArray<NSString *> *axisLabels;
@property (nonatomic, nonnull, readonly) NSArray<NSString *> *axisSubLabels;

@end
