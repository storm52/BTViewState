//
//  BTViewStateProperty.m
//  TopBroker3
//
//  Created by Xcode on 2016/11/10.
//  Copyright © 2016年 kakao. All rights reserved.
//

#import "BTViewStateProperty.h"

#define defaultNoDataImageKey @"defaultNoDataImage"
#define defaultErrorImageKey @"defaultErrorImageKey"
#define defaultNetworkFailImageKey @"defaultNetworkFailImageKey"
#define defaultNoDataTitleKey @"defaultNoDataTitleKey"
#define defaultErrorTitleKey @"defaultErrorTitleKey"
#define defaultNetworkFailTitleKey @"defaultNetworkFailTitleKey"

@interface BTViewStateProperty ()
@property(nonatomic,strong)NSMutableDictionary *customerViewDictionary;
@end

@implementation BTViewStateProperty
+ (instancetype)sharedInstance{
    static BTViewStateProperty *property = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        property = [[self alloc] init];
    });
    return property;
}
+ (void)setImageNoData:(UIImage *)noData error:(UIImage *)error network:(UIImage *)networkfail{
     [[[self sharedInstance] customerViewDictionary] setObject:noData forKey:defaultNoDataImageKey];
     [[[self sharedInstance] customerViewDictionary] setObject:error forKey:defaultErrorImageKey];
     [[[self sharedInstance] customerViewDictionary] setObject:networkfail forKey:defaultNetworkFailImageKey];
}
+ (void)setTitleNoData:(NSString *)noData error:(NSString *)error network:(NSString *)networkfail{
     [[[self sharedInstance] customerViewDictionary]  setObject:noData forKey:defaultNoDataTitleKey];
    [[[self sharedInstance] customerViewDictionary]  setObject:error forKey:defaultErrorTitleKey];
     [[[self sharedInstance] customerViewDictionary]  setObject:networkfail forKey:defaultNetworkFailTitleKey];
}
+(instancetype)defaultProperties{
    BTViewStateProperty *properties=[[BTViewStateProperty alloc] init];
    return properties;
}


-(void)setText:(NSString *)text forLoadState:(BTViewState)loadState{
    if (text) {
        [self.customerViewDictionary setObject:text forKey: [NSString stringWithFormat:@"text_%@",@(loadState)]];
    }
}

- (NSString *)textForState:(BTViewState)loadState{
    NSString *text = [self.customerViewDictionary objectForKey: [NSString stringWithFormat:@"text_%@",@(loadState)]];
    if (text == nil) {
        switch (loadState) {
            case BTViewStateNoData:
                text = [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultNoDataTitleKey];
                break;
            case BTViewStateError:
                 text = [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultErrorTitleKey];
                break;
            default:
               text = [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultNetworkFailTitleKey];
                break;
        }
    }
    return text;
}

- (void)setDetail:(NSString *)text forLoadState:(BTViewState)loadState{
    if (text) {
        [self.customerViewDictionary setObject:text forKey: [NSString stringWithFormat:@"detail_%@",@(loadState)]];
    }
}
- (NSString *)detailForState:(BTViewState)loadState{
    NSString *text = [self.customerViewDictionary objectForKey: [NSString stringWithFormat:@"detail_%@",@(loadState)]];
    if (text == nil) {
        switch (loadState) {
            default:
                text = @"";
                break;
        }
    }
    return text;
}

-(void)setImage:(UIImage *)image forLoadState:(BTViewState)loadState{
    if (image) {
        [self.customerViewDictionary setObject:image forKey: [NSString stringWithFormat:@"img_%@",@(loadState)]];
    }
}

- (UIImage *)imageForState:(BTViewState)loadState{
    UIImage *img = [self.customerViewDictionary objectForKey: [NSString stringWithFormat:@"img_%@",@(loadState)]];
    if (img == nil) {

        switch (loadState) {
            case BTViewStateNoData:
                img = [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultNoDataImageKey];
                break;
            case BTViewStateError:
                img =  [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultErrorImageKey];
                break;
            case BTViewStateNetworkFail:
                img =  [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultNetworkFailImageKey];
                break;
            default:
                 img = [[[BTViewStateProperty sharedInstance] customerViewDictionary] valueForKey:defaultErrorImageKey];
                break;
        }
    }
    return img;
}


-(void)setCustomerView:(UIView *)view forLoadState:(BTViewState)loadState{
    if (view) {
        [self.customerViewDictionary setObject:view forKey:@(loadState)];
    }
}
-(UIView *)customerViewForLoadState:(BTViewState)loadState{
    return [self.customerViewDictionary objectForKey:@(loadState)];
}


-(NSMutableDictionary *)customerViewDictionary{
    if (!_customerViewDictionary) {
        _customerViewDictionary=[NSMutableDictionary dictionaryWithCapacity:15];
    }
    return _customerViewDictionary;
}

@end
