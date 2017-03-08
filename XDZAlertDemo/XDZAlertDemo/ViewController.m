//
//  ViewController.m
//  XDZAlertDemo
//
//  Created by bestkai on 2017/2/7.
//  Copyright © 2017年 bestkai. All rights reserved.
//

#import "ViewController.h"
#import "XDZAlertController.h"
#import "SecondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *customBt = [UIButton buttonWithType:UIButtonTypeSystem];
    
//    customBt.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 60);
    customBt.translatesAutoresizingMaskIntoConstraints = NO;
    customBt.backgroundColor = [UIColor redColor];
    [customBt setTitle:@"Custom" forState:UIControlStateNormal];
    [customBt addTarget:self action:@selector(showCustomAlertController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customBt];
    
    
    // align customBt from the left and right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customBt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customBt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customBt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:customBt attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
 
    
    
    UIButton *systemBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [systemBt addTarget:self action:@selector(showSystemAlertViewController) forControlEvents:UIControlEventTouchUpInside];
    systemBt.backgroundColor = [UIColor blackColor];
    [systemBt setTitle:@"System" forState:UIControlStateNormal];
    systemBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:systemBt];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:systemBt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:customBt attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:systemBt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:customBt attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:systemBt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:customBt attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:systemBt attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:customBt attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view layoutIfNeeded];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.userInteractionEnabled = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"First";
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextVC)]];
}


- (void)showCustomAlertController
{
//    XDZAlertController *alertVC = [XDZAlertController alertControllerWithTitle:[[NSAttributedString alloc] initWithString:@"我是Title" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}] message:[[NSAttributedString alloc] initWithString:@"我是Message" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}] preferredStyle:XDZAlertControllerStyleAlert];
    
    XDZAlertController *alertVC = [XDZAlertController alertControllerWithTitle:nil message:nil preferredStyle:XDZAlertControllerStyleAlert];

    
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
}



- (void)showSystemAlertViewController
{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我是Title" message:@"我是Message" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:@"destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *otherAction2 = [UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *otherAction3 = [UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *otherAction4 = [UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];    UIAlertAction *otherAction5 = [UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];    UIAlertAction *otherAction6 = [UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction1];
//    [alertController addAction:otherAction2];
//    [alertController addAction:otherAction3];
//    [alertController addAction:otherAction4];
//    [alertController addAction:otherAction5];
//    [alertController addAction:otherAction6];

    
    [self.navigationController presentViewController:alertController animated:YES completion:^{
    }];
}


- (void)goToNextVC
{
    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
