# BTViewState

[![CI Status](https://img.shields.io/travis/xcode/BTViewState.svg?style=flat)](https://travis-ci.org/xcode/BTViewState)
[![Version](https://img.shields.io/cocoapods/v/BTViewState.svg?style=flat)](https://cocoapods.org/pods/BTViewState)
[![License](https://img.shields.io/cocoapods/l/BTViewState.svg?style=flat)](https://cocoapods.org/pods/BTViewState)
[![Platform](https://img.shields.io/cocoapods/p/BTViewState.svg?style=flat)](https://cocoapods.org/pods/BTViewState)

## Example
![image](https://github.com/storm52/BTViewState/blob/master/demo.gif)
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 使用

设置默认状态图片与提示
```

[BTViewStateProperty setImageNoData:[UIImage imageNamed:@"Common_problem_none records"] error:[UIImage imageNamed:@"Common_problem_no data"] network:[UIImage imageNamed:@"Common_problem_network"]];
[BTViewStateProperty setTitleNoData:@"暂无记录" error:@"失败" network:@"网络错误"];
```
指定视图状态
```
self.view.viewState = BTViewStateLoading;

tableView.viewState = BTViewStateLoading;

button.viewState = BTViewStateLoading;

```

更多视图属性设置
```

tableView.stateProperties.loadingAreaInsets = UIEdgeInsetsMake(152, 0, 0, 0);
tableView.stateProperties.contentVerticalOffset = -75;
tableView.stateProperties.noDataActionBlock = ^{
    [weakSelf reloadData];
};
view.stateProperties.labelOffset = -20;

[tableView.stateProperties setImage:UIImage.new forLoadState:BTViewStateNoData];

```
更多等......你探索

## Installation

BTViewState is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:



```ruby
pod 'BTViewState'
```

## Author

 liuwuxiong@btb.com

## License

BTViewState is available under the MIT license. See the LICENSE file for more info.
