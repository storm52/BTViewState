//
//  UIView+State.h
//  investment
//
//  Created by apple on 15/11/2.
//  Copyright (c) 2015年 touzila. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BTViewStateProperty;



typedef NS_ENUM(NSInteger,BTViewState){
    BTViewStateDefault=0,
    BTViewStateLoading,//起始加载状态,一个indicatorView在中间
    BTViewStateNoData,//无数据状态
    BTViewStateNetworkFail,//无网络状态
    BTViewStateError //其他错误
};

/*
 一行代码设置加载状态
 self.view.currentLoadingState=BTViewState;
 或 self.tableView.currentLoadingState=BTViewState;
 
 其它可设置属性，可在loadingStateProperties设置
 加载区域为self 的父类bounds
 并将加载view加入到self的superview子视图
 */


@interface UIView (State)
@property(nonatomic)BTViewState viewState;
@property(nonatomic,readonly)BTViewStateProperty *stateProperties;

- (void)setStateWithError:(NSError *)error;
- (void)setStateWithArray:(NSArray *)list Error:(NSError *)error;

@end



#import "BTViewStateProperty.h"
