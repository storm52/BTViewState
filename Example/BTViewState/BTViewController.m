//
//  BTViewController.m
//  BTViewState
//
//  Created by xcode on 05/08/2018.
//  Copyright (c) 2018 xcode. All rights reserved.
//

#import "BTViewController.h"
#import <BTViewState/UIView+State.h>
#import <Masonry/Masonry.h>
#import "TestViewController.h"
#import "MoreViewController.h"

@interface BTViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@end

@implementation BTViewController

- (void)viewDidLoad
{
    self.navigationItem.title = @"BTViewStatetitle Demo";
    [super viewDidLoad];
    self.titleArray = @[@"BTViewStateLoading",@"BTViewStateNoData",@"BTViewStateNetworkFail",@"BTViewStateError",@"More usage"];
    self.tableView = UITableView.new;
    self.tableView.dataSource=self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = self.titleArray[indexPath.item];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==self.titleArray.count-1) {
        MoreViewController *vc = MoreViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    TestViewController *vc = TestViewController.new;
    vc.initState = indexPath.row+1;
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (void)click:(UIButton *)sender
{
    [self.view.stateProperties setImage:[UIImage imageNamed:@"Common_problem_no data"] forLoadState:BTViewStateNoData];
    //    self.view.viewState = BTViewStateLoading;
    
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(20,150, 100, 40)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:UIColor.greenColor];
    [self.view addSubview:btn];
    
    UIButton *btn2= [[UIButton alloc] initWithFrame:CGRectMake(20,300, 100, 40)];
    [self.view addSubview:btn2];
    btn2.viewState=BTViewStateNetworkFail;
    self.tableView.stateProperties.loadingAreaInsets = UIEdgeInsetsMake(128, 0, 0, 0);
    self.tableView.viewState = BTViewStateNoData;
    sender.viewState = BTViewStateLoading;
    NSLog(@"click testx");
    // Dispose of any resources that can be recreated.
}

@end
