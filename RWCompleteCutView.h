//
//  RWCompleteCutView.h
//  RWCompleteCutAnimation
//
//  Created by zhongyu on 16/6/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@class RWCardContentView,RWCompleteCutViewCell,RWCardContentView;

typedef NS_ENUM(NSInteger,RWChangeViewState)
{
    RWChangeViewStateToNextView     = 1 << 1,
    RWChangeViewStateToFrontView    = 1 << 2
};

@protocol RWCompleteCutViewDelegate <NSObject>

@optional

- (void)revolveDidChangeViewWithState:(RWChangeViewState)state;

- (void)buttonDidClickWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface RWCardContentView : UIView

@property (nonatomic,assign)id<RWCompleteCutViewDelegate> delegate;

@property (nonatomic,strong)NSString *contentImage;

@property (nonatomic,strong)NSString *buttonText;

@property (nonatomic,strong)NSString *footerText;

@end

typedef NS_ENUM(NSInteger,RWContentView)
{
    RWContentViewOfMain             = 2,
    RWContentViewOfTranslucent      = 1,
    RWContentViewOfBottom           = 0
};

@interface RWCompleteCutViewCell : UICollectionViewCell

@property (nonatomic,assign)id<RWCompleteCutViewDelegate> delegate;

@property (nonatomic,strong,readonly)NSArray *contentViews;

@property (nonatomic,strong)NSArray *contentDatas;

@property (nonatomic,strong)NSString *number;

@property (nonatomic,strong)NSIndexPath *indexPath;

- (void)didInThisView;

@end

@interface RWCompleteCutView : UICollectionView

- (instancetype)initWithConstraint:(void(^)(MASConstraintMaker *make))constraint;

@property (nonatomic,assign)id<RWCompleteCutViewDelegate> eventSource;

@property (nonatomic,strong)NSArray *cardSource;

@property (nonatomic,copy,readonly)void(^constraint)(MASConstraintMaker *make);

- (void)setConstraint:(void (^)(MASConstraintMaker *))constraint;

@end
