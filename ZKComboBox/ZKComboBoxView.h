//
//  ZKComboBoxView.h
//  ZKComboBox
//
//  Created by lee on 16/2/14.
//  Copyright (c) 2016年 sanchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKComboBoxView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UIButton *selectButton;
@property(nonatomic)NSString *selectValue;
@property(nonatomic)NSArray *comboBoxDatasource;
@property(nonatomic)BOOL isShow;
@end
