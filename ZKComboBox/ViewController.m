//
//  ViewController.m
//  ZKComboBox
//
//  Created by lee on 16/2/14.
//  Copyright (c) 2016年 sanchun. All rights reserved.
//

#import "ViewController.h"
#import "ZKComboBoxView.h"

#import <Masonry/Masonry.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZKComboBoxView *comboxView = [[ZKComboBoxView alloc]initWithFrame:CGRectMake(0, 100, 200, 30)];
    comboxView.data = @[@"11",@"222",@"333",@"444"];
    comboxView.tableHeight = ZKComboBoxViewAutoHeight;
    [self.view addSubview:comboxView];
    [comboxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
