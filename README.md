# XDZAlertController
封装AlertViewController，AutoLayout 实现AlertController

系统Autolayout实现alertController，ios7+
用法和系统UIAlertController 一样，通过NSAttributedString定义文本，比系统更灵活。

可自定义圆角、间距、分割线颜色等属性。

example:

```
    XDZAlertController *alertVC = [XDZAlertController alertControllerWithTitle:[[NSAttributedString alloc] initWithString:@"我是Title" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}] message:[[NSAttributedString alloc] initWithString:@"我是Message" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}] preferredStyle:XDZAlertControllerStyleAlert];
    
//    XDZAlertController *alertVC = [XDZAlertController alertControllerWithTitle:nil message:nil preferredStyle:XDZAlertControllerStyleAlert];

    
    XDZAlertAction *confirmaction = [XDZAlertAction actionWithTitle:[[NSAttributedString alloc] initWithString:@"Action1" attributes:@{}] style:XDZAlertActionStyleDefault handler:^(XDZAlertAction *action) {
        NSLog(@"%@",action.title.string);
    }];
    
    XDZAlertAction *otheraction = [XDZAlertAction actionWithTitle:[[NSAttributedString alloc] initWithString:@"Action2" attributes:@{}] style:XDZAlertActionStyleDefault handler:^(XDZAlertAction *action) {
        NSLog(@"%@",action.title.string);
    }];
    
    XDZAlertAction *cancelaction = [XDZAlertAction actionWithTitle:[[NSAttributedString alloc] initWithString:@"取消" attributes:@{}] style:XDZAlertActionStyleCancel handler:^(XDZAlertAction *action) {
        NSLog(@"%@",action.title.string);
    }];

    [alertVC addAcion:confirmaction];
    [alertVC addAcion:otheraction];
    [alertVC addAcion:cancelaction];
    
    
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    
```

