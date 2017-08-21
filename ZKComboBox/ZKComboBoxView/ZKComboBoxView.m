//
//  ZKComboBoxView.m
//  ZKComboBox
//
//  Created by lee on 16/2/14.
//  Copyright (c) 2016年 sanchun. All rights reserved.
//

#import "ZKComboBoxView.h"
#import <Masonry/Masonry.h>

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

#define kDefaultTableHeight 100.f

double const ZKComboBoxViewAutoHeight =  123456.654321;

@interface ZKComboBoxView()
{

}
@property (nonatomic,strong) MASConstraint *tableHeightConstraint;
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
    _rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_dark"]];
    [self addSubview:_rightView];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.and.right.mas_equalTo(-5);
        make.width.mas_equalTo(_rightView.mas_height);
    }];
    
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = self.frame;
    [_selectButton addTarget:self action:@selector(touchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_selectButton];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
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
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_bottom);
            self.tableHeightConstraint = make.height.mas_equalTo(0);
        }];
        
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
        
        [self.tableHeightConstraint uninstall];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_bottom);
            self.tableHeightConstraint = make.height.mas_equalTo(self.tableHeight);
        }];
   
        [self layoutIfNeeded];  //这行代码如果不用self刷新的话，动画会不对
    }];
}

- (void)hidenSelectTable {
    self.selectButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform = CGAffineTransformRotate(_rightView.transform, DEGREES_TO_RADIANS(180));
        
        [self.tableHeightConstraint uninstall];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_bottom);
            self.tableHeightConstraint = make.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
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
