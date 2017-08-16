//
//  ZKComboBoxView.m
//  ZKComboBox
//
//  Created by lee on 16/2/14.
//  Copyright (c) 2016年 sanchun. All rights reserved.
//

#import "ZKComboBoxView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@interface ZKComboBoxView()
{
    UIImageView *_icoView;
    UITableView *_comboBoxTableView;
}
@end
@implementation ZKComboBoxView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubViewWithFrame:frame];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.selectValue = @"--";
    }
    return self;
}
-(void)setSelectValue:(NSString *)selectValue
{
    _selectValue = selectValue;
    [self.selectButton setTitle:selectValue forState:UIControlStateNormal];
}
-(void)initSubViewWithFrame:(CGRect)frame
{
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.selectButton addTarget:self action:@selector(touchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectValue = @"--";
    [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.selectButton];
    
    _icoView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 16.0f, (self.frame.size.height - 12)/2, 12, 12)];
    _icoView.image = [UIImage imageNamed:@"down_dark.png"];
    [self addSubview:_icoView];
    
}
-(void)touchBtnAction:(UIButton *)selectBtn
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _icoView.transform = CGAffineTransformRotate(_icoView.transform, DEGREES_TO_RADIANS(180));
    }];
    if (selectBtn.selected) {
        [self hidenSelectTable];
    }
    else
    {
        [self showSelectTable];
    }
    
    selectBtn.selected = !selectBtn.selected;
}
-(void)showSelectTable
{
    if (_comboBoxTableView == nil) {
        _comboBoxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
        _comboBoxTableView.layer.borderWidth = 1.0f;
        _comboBoxTableView.layer.borderColor = [UIColor blackColor].CGColor;
        _comboBoxTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _comboBoxTableView.delegate = self;
        _comboBoxTableView.dataSource = self;
        [self addSubview:_comboBoxTableView];
    }
    CGRect rect = _comboBoxTableView.frame;
    rect.size.height = CGRectGetHeight(self.frame) * 3 + 10;
    [UIView animateWithDuration:0.3 animations:^{
        _comboBoxTableView.frame = rect;
    }];
    [_comboBoxTableView reloadData];
}
-(void)hidenSelectTable
{
    CGRect rect = _comboBoxTableView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _comboBoxTableView.frame = rect;
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comboBoxDatasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    NSString *item = self.comboBoxDatasource[indexPath.row];
    cell.textLabel.text = item;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(_comboBoxTableView.frame, point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectValue = self.comboBoxDatasource[indexPath.row];
    [self hidenSelectTable];
}
@end
