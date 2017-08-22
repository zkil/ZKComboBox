# ZKComboBox
## 简介
一个抽屉下拉选择框  
### 效果
![](https://github.com/zkil/ZKComboBox/blob/master/timeline.gif?raw=true)  

### 使用
导入 `ZKComboBoxView` 文件夹到工程

`#import "ZKComboBoxView.h"`  

### 创建 
```
ZKComboBoxView *comboxView = [[ZKComboBoxView alloc]initWithFrame:CGRectMake(0, 100, 200, 30)];
comboxView.data = @[@"11",@"222",@"333",@"444"];
[self.view addSubview:comboxView];

```

### 设置选择列表的高度
```
comboxView.tableHeight = 100.f;
```

### 或者设置列表高度随内容
```
comboxView.tableHeight = ZKComboBoxViewAutoHeight;
```
