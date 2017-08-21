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

#define kDefaultTableHeight 100.f

double const ZKComboBoxViewAutoHeight =  123456.654321;

@interface ZKComboBoxView()
{

}
@end

@implementation ZKComboBoxView
@synthesize tableView = _tableView, tableHeight = _tableHeight;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        _tableHeight = kDefaultTableHeight;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat margin = 5;
    CGFloat width = self.frame.size.height - margin * 2;
    _rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_dark"]];
    _rightView.frame = CGRectMake(self.frame.size.width - width - margin, margin, width, width);
    _rightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_rightView];
    
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = self.bounds;
    [_selectButton addTarget:self action:@selector(touchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_selectButton];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
        _tableView.layer.borderWidth = 1.0f;
        _tableView.layer.borderColor = [UIColor blackColor].CGColor;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsZero;
        [self addSubview:_tableView];
        
        
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];

    }
    return _tableView;
}

- (NSString *)displayText {
    return self.selectButton.titleLabel.text;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (selectIndex < 0 || selectIndex >= self.data.count) {
        [self.selectButton setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    [self.selectButton setTitle:self.data[selectIndex] forState:UIControlStateNormal];
}

- (CGFloat)tableHeight {
    if (_tableHeight == ZKComboBoxViewAutoHeight) {
        CGFloat height = self.superview.frame.size.height - CGRectGetMaxY(self.frame);
        if (self.tableView.contentSize.height > height) {
            return height;
        } 
        
        return self.tableView.contentSize.height;
    } else {
        return _tableHeight;
    }
}

- (void)setTableHeight:(CGFloat)tableHeight {
    _tableHeight = tableHeight;
    if (self.selectButton.selected) {
        [self showSelectTable];
    } else {
        [self hidenSelectTable];
    }
}

- (void)touchBtnAction:(UIButton *)selectBtn {
    
    if (selectBtn.selected) {
        [self hidenSelectTable];
    } else {
        [self showSelectTable];
    }
    
}

- (void)showSelectTable {
    
    self.selectButton.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform = CGAffineTransformRotate(_rightView.transform, DEGREES_TO_RADIANS(180));
        CGRect frame = self.tableView.frame;
        frame.size.height = self.tableHeight;
        self.tableView.frame = frame;
        
    }];
}

- (void)hidenSelectTable {
    self.selectButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform = CGAffineTransformRotate(_rightView.transform, DEGREES_TO_RADIANS(180));
        CGRect frame = self.tableView.frame;
        frame.size.height = 0;
        self.tableView.frame = frame;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    NSString *item = self.data[indexPath.row];
    cell.textLabel.text = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height;
}

//使点击事件范围在视图外
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self hidenSelectTable];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.selectButton.selected) {
            [self showSelectTable];
        }
    }
}

- (void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

@end
