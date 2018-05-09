//
//  BTViewStateProperty.h
//  TopBroker3
//
//  Created by Xcode on 2016/11/10.
//  Copyright © 2016年 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+State.h"

typedef void (^NetworkReloadBlock)(void);
typedef void (^NoDataActionBlock)(void);

@interface BTViewStateProperty : NSObject

+ (void)setImageNoData:(UIImage *)noData error:(UIImage *)error network:(UIImage *)networkfail;
+ (void)setTitleNoData:(NSString *)noData error:(NSString *)error network:(NSString *)networkfail;

//网络加载失败视图，指定的点击重新加载执行的block


@property(nonatomic,copy)NoDataActionBlock noDataActionBlock;

/*
 加载区域insets
 */

@property(nonatomic,assign)CGFloat contentVerticalOffset;//默认为0，居中,小于0向上偏移，大于0向下
@property(nonatomic,assign)CGFloat labelOffset;//默认为0，图片下方
@property(nonatomic,assign)UIEdgeInsets loadingAreaInsets;
@property(nonatomic,assign)BOOL ignoreNavBar;//忽略导航高度，默认NO

@property(nonatomic,assign)CGFloat indicatorOffsetX;
@property(nonatomic,assign)CGFloat indicatorOffsetY;
@property(nonatomic,assign)CGFloat indicatorAlpha;

-(void)setImage:(UIImage *)image forLoadState:(BTViewState)loadState;
- (UIImage *)imageForState:(BTViewState)loadState;

- (NSString *)textForState:(BTViewState)loadState;
-(void)setText:(NSString *)text forLoadState:(BTViewState)loadState;
- (NSString *)detailForState:(BTViewState)loadState;
-(void)setDetail:(NSString *)text forLoadState:(BTViewState)loadState;

/*
 设置自定义视图
 */
- (void)setCustomerView:(UIView*)view forLoadState:(BTViewState)loadState;
/*
 获取设置的自定义视图，由UIView (State) 调用
 */
-(UIView*)customerViewForLoadState:(BTViewState)loadState;


+(instancetype)defaultProperties;

@end
