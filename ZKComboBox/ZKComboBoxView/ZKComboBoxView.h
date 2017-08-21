//
//  ZKComboBoxView.h
//  ZKComboBox
//
//  Created by lee on 16/2/14.
//  Copyright (c) 2016年 sanchun. All rights reserved.
//

#import <UIKit/UIKit.h>
extern double const ZKComboBoxViewAutoHeight;

@interface ZKComboBoxView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *selectButton;
//右侧图标
@property (nonatomic,strong,readonly) UIImageView *rightView;
@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong) NSArray<NSString *> *data;
@property (nonatomic,readonly) NSString *displayText;
//选中项
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic) CGFloat tableHeight;

@end
