//
//  UIView+State.m
//  investment
//
//  Created by apple on 15/11/2.
//  Copyright (c) 2015年 touzila. All rights reserved.
//



#import "UIView+State.h"
#import <objc/runtime.h>
#import "Masonry/Masonry.h"

const char * kNoDateStateViewKey = "kNoDateStateViewKey";
const char * kNetworkFailStateViewKey = "kNetworkFailStateViewKey";
const char * kErrorStateViewKey = "kErrorStateViewKey";

@interface ImageWithTitleView : UIView

-(instancetype)initWithOffSetY:(CGFloat)yOffSet labelOffset:(CGFloat)labelOffset;

@property(nonatomic,strong)UIButton *imageView;
@property(nonatomic,strong)UIButton *titleLabel;
@property(nonatomic,strong)UIButton *detailLabel;
@end

@implementation UIView (State)


@dynamic viewState;


-(void)setViewState:(BTViewState)currentLoadingState{
    
    if (self.viewState!=currentLoadingState) {
        if (self.viewState==BTViewStateDefault) {
            //do nothing
        }
        else if (self.viewState==BTViewStateLoading) {
            UIView *stateView=self.loadingView;
            [UIView animateWithDuration:0.3 animations:^{
                stateView.alpha=0;
            } completion:^(BOOL finished) {
                [stateView removeFromSuperview];
                self.kkLoadingDataView=nil;
            }];
        }else{
           UIView *stateView=[self statusViewForState:self.viewState];
            [self setStatusView:nil forState:self.viewState];
           [UIView animateWithDuration:0.3 animations:^{
               stateView.alpha=0;
           } completion:^(BOOL finished) {
               [stateView removeFromSuperview];
               stateView.alpha = 1;
           }];
        }

        objc_setAssociatedObject(self, @selector(viewState), @(currentLoadingState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //放在superview上可以防止直接放在self上会出现点击事件传递到原界面情况
        UIView *superView=self.superview;
        if (![superView isKindOfClass:[UIView class]]
            || [self isKindOfClass:[UITableView class]]) {
            superView=self;
        }
        UIView *stateView=nil;
        switch (currentLoadingState) {
            case BTViewStateDefault:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.alpha=1.0;
                }];
            }
                break;
            case BTViewStateLoading:
            {
                stateView=self.loadingView;
            }
                break;
          
            case BTViewStateNoData:
            case BTViewStateNetworkFail:
            case BTViewStateError:
                stateView=[self statusViewForState:currentLoadingState];
                break;
        }
        if (stateView) {
            [superView addSubview:stateView];
            stateView.alpha = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                stateView.alpha=1.0;
            }];
            UIEdgeInsets insets=self.stateProperties.loadingAreaInsets;
            [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(insets.top);
                make.left.equalTo(self).with.offset(insets.left);
                make.bottom.equalTo(self).with.offset(-insets.bottom);
                make.right.equalTo(self).with.offset(-insets.right);
                if ([superView isKindOfClass:[UIScrollView class]]) {
                    make.width.equalTo(superView.mas_width);
                    make.height.equalTo(superView.mas_height).offset(-insets.top-insets.bottom);
                }
            }];
            [superView bringSubviewToFront:stateView];
        }
        
    }
}
-(BTViewState)viewState{
    return [objc_getAssociatedObject(self, @selector(viewState)) integerValue];
}
- (void)setStateWithArray:(NSArray *)list Error:(NSError *)error{
    if (list.count>0 || (![list isKindOfClass:NSArray.class] && error == nil )) {
        self.viewState = BTViewStateDefault;
    }else if ((list && list.count==0) && error==nil) {
        self.viewState = BTViewStateNoData;
    }else if (error){
        [self.stateProperties setText:error.localizedDescription forLoadState:BTViewStateError];
        if (error.code == -1009) {
            self.viewState = BTViewStateNetworkFail;
        }else{
            if (error.code == 404 && [self.stateProperties imageForState:BTViewStateError]==nil) {
                [self.stateProperties setImage:[UIImage imageNamed:@"Common_problem_service 404"] forLoadState:BTViewStateError];
            }
            self.viewState = BTViewStateError;
        }
    }
}
- (void)setStateWithError:(NSError *)error{
    [self setStateWithArray:nil Error:error];
}



-(BTViewStateProperty *)stateProperties{
    if (objc_getAssociatedObject(self, _cmd)==nil) {
        BTViewStateProperty *properties=[BTViewStateProperty defaultProperties];
        objc_setAssociatedObject(self, _cmd, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return properties;
    }else{
        return objc_getAssociatedObject(self, _cmd);
    }
}

- (UIView *)statusViewForState:(BTViewState)state{
    
    UIView *statusView = objc_getAssociatedObject(self, [self statusViewKeyForState:state]);
    if (statusView!=nil) {
        return statusView;
    }
    UIView *bgView=UIView.new;
    bgView.backgroundColor=UIColor.whiteColor;
    UIView *customerView=[self.stateProperties customerViewForLoadState:state];
    if (customerView) {
        [bgView addSubview:customerView];
        [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];

    }else{
        ImageWithTitleView *statusView=[[ImageWithTitleView alloc] initWithOffSetY:self.stateProperties.contentVerticalOffset labelOffset:self.stateProperties.labelOffset];
        UIImage *img = [self.stateProperties imageForState:state];
        [statusView.imageView setImage:img forState:UIControlStateNormal];
        NSString *text = [self.stateProperties textForState:state];
        [statusView.titleLabel setTitle:text forState:UIControlStateNormal];
        NSString *detail = [self.stateProperties detailForState:state];
        [statusView.detailLabel setTitle:detail forState:UIControlStateNormal];
        [statusView.titleLabel addTarget:self action:@selector(clickedImageOrTitle) forControlEvents:UIControlEventTouchUpInside];
        [statusView.imageView addTarget:self action:@selector(clickedImageOrTitle) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:statusView];
        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];
    }
    [self setStatusView:bgView forState:state];
    return bgView;
}
- (const char *)statusViewKeyForState:(BTViewState)state{
    const char * stateKey;
    switch (state) {
        case BTViewStateNoData:
            stateKey =kNoDateStateViewKey;
            break;
        case BTViewStateNetworkFail:
            stateKey =kNetworkFailStateViewKey;
            break;
        case BTViewStateError:
            stateKey =kErrorStateViewKey;
            break;
        default:
            stateKey ="";
            break;
    }
    return stateKey;
}
-(void)setStatusView:(UIView *)statusView forState:(BTViewState)state{
//  key值必须是常量指针，而不能用字符串拼接
    objc_setAssociatedObject(self, [self statusViewKeyForState:state], statusView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
}


-(UIView*)loadingView{
    if (objc_getAssociatedObject(self, _cmd)==nil) {
        UIView *bgView=UIView.new;
        bgView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
        UIView *customerView=[self.stateProperties customerViewForLoadState:BTViewStateLoading];
        if (customerView) {
            [bgView addSubview:customerView];
            [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }else{
            UIActivityIndicatorView *indicator = UIActivityIndicatorView.new;
            indicator.backgroundColor= UIColor.clearColor;
            [bgView addSubview:indicator];
            indicator.color = UIColor.darkGrayColor;
            [indicator startAnimating];
            indicator.hidesWhenStopped = YES;
            [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bgView).offset(self.stateProperties.indicatorOffsetX);
                make.centerY.equalTo(bgView).offset(self.stateProperties.indicatorOffsetY);
            }];
        }
        self.kkLoadingDataView=bgView;
        return bgView;
    }else{
        return objc_getAssociatedObject(self, _cmd);
    }
}
-(void)setKkLoadingDataView:(UIView *)kkLoadingDataView{
    
    objc_setAssociatedObject(self, @selector(loadingView), kkLoadingDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)clickedImageOrTitle{
    if (self.stateProperties.noDataActionBlock) {
        self.stateProperties.noDataActionBlock();
    }
}

@end

@implementation ImageWithTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       self= [self initWithOffSetY:0 labelOffset:15];
    }
    return self;
}

-(instancetype)initWithOffSetY:(CGFloat)yOffSet labelOffset:(CGFloat)labelOffset{
    if (self=[super initWithFrame:CGRectZero]) {
        
        self.imageView=[[UIButton alloc] init];
        self.imageView.userInteractionEnabled=YES;
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel=[[UIButton alloc] init];
        
        self.titleLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.titleLabel.numberOfLines=0;
        [self.titleLabel setTitleColor:[UIColor colorWithRed:195/255.0 green:199/255.0 blue:205/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        self.titleLabel.titleLabel.font=[UIFont boldSystemFontOfSize:15];
       
       
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
      
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLabel);
            make.centerY.equalTo(self.mas_centerY).multipliedBy(0.8).offset(yOffSet);
            make.width.equalTo(self).multipliedBy(0.3).priorityLow();
            make.height.mas_equalTo(30).priorityLow();
            
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(labelOffset);
            make.centerX.width.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        self.detailLabel=UIButton.new;
        self.detailLabel.titleLabel.font=[UIFont systemFontOfSize:13];
        self.detailLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.detailLabel.titleLabel.numberOfLines=0;
        [self.detailLabel setTitleColor:[UIColor colorWithRed:195/255.0 green:199/255.0 blue:205/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView.mas_centerX);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
            make.width.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}



@end
