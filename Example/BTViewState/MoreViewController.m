//
//  MoreViewController.m
//  BTViewState_Example
//
//  Created by xcode on 2018/5/9.
//  Copyright © 2018年 xcode. All rights reserved.
//

#import "MoreViewController.h"
#import <BTViewState/UIView+State.h>

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *partView;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn2.stateProperties.indicatorOffsetX=60; self.partView.stateProperties.loadingAreaInsets= UIEdgeInsetsMake(40, 0, 0, 0);
    self.partView.viewState = BTViewStateNetworkFail;
    __weak typeof(self.partView) weakSelf = self.partView;
    self.partView.stateProperties.noDataActionBlock = ^{
        weakSelf.viewState = BTViewStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             weakSelf.viewState = BTViewStateNoData;
        });
       
    };
    
}
- (IBAction)clickBtn:(UIButton *)sender {
    sender.viewState = BTViewStateLoading;
}
- (IBAction)clickBtn2:(UIButton *)sender {
    sender.viewState = BTViewStateLoading;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
