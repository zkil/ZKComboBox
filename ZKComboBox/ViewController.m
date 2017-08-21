//
//  ViewController.m
//  ZKComboBox
//
//  Created by lee on 16/2/14.
//  Copyright (c) 2016年 sanchun. All rights reserved.
//

#import "ViewController.h"
#import "ZKComboBoxView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZKComboBoxView *comboxView = [[ZKComboBoxView alloc]initWithFrame:CGRectMake(0, 100, 200, 30)];
    comboxView.tableHeight = ZKComboBoxViewAutoHeight;
    comboxView.data = @[@"11",@"222",@"333",@"444"];
    [self.view addSubview:comboxView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
