//
//  XDZAlertController.m
//  XDZAlertDemo
//
//  Created by bestkai on 2017/2/7.
//  Copyright © 2017年 bestkai. All rights reserved.
//

#import "XDZAlertController.h"


static CGFloat XDZAlertVerticalSpace = 3;

@implementation XDZAlertAction

+ (instancetype)actionWithTitle:(NSAttributedString *)title style:(XDZAlertActionStyle)style handler:(void (^)(XDZAlertAction *))handler
{
    
    XDZAlertAction *action = [[XDZAlertAction alloc] init];
    
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}

@end


@implementation XDZActionButton

@end



@interface XDZAlertController ()<UIGestureRecognizerDelegate>
{
    NSLayoutConstraint *containerTopConstraint;
}

@property (nonatomic, strong) UIView *alphaBackView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) XDZAlertAction *cancelAction;

/**
 去除cancelAction  其他action
 */
@property (nonatomic, strong) NSMutableArray *defaultActions;
/**
 所有的action
 */
@property (nonatomic, strong) NSMutableArray *alertActions;

@end

@implementation XDZAlertController

+ (instancetype)alertControllerWithTitle:(NSAttributedString *)alertTitle message:(NSAttributedString *)message preferredStyle:(XDZAlertControllerStyle)preferredStyle
{
    XDZAlertController *alertController = [[self alloc] initWithTitle:alertTitle message:message preferredStyle:preferredStyle];
    
    if (alertController) {
        return alertController;
    }
    return nil;
}

- (instancetype)initWithTitle:(NSAttributedString *)alertTitle message:(NSAttributedString *)message preferredStyle:(XDZAlertControllerStyle)preferredStyle
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.alertTitle = alertTitle;
        self.message = message;
        self.preferredStyle = preferredStyle;
        
        self.defaultActions = [[NSMutableArray alloc] init];
        self.alertActions = [[NSMutableArray alloc] init];
        
        self.contentCornerRadius = 4;
        self.alertActionHeight = 50;
        self.titleMessageSpacing = 18;

        if (preferredStyle == XDZAlertControllerStyleAlert) {
            self.alertContentMaximumWidth = 270;
        }else{
        self.sheetContentMargin = 10;
        }
    }
    return self;
}

- (void)addAcion:(XDZAlertAction *)action
{
    if (action.style == XDZAlertActionStyleCancel && self.cancelAction) {
        [NSException raise:@"XDZAlertController使用错误" format:@"同一个alertController不可以同时添加两个cancel按钮"];
    }
    
    if (action.style == XDZAlertActionStyleCancel) {
        self.cancelAction = action;
    }else{
        [self.defaultActions addObject:action];
    }
    
    [self.alertActions addObject:action];
}


- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _containerView;
}

- (UIView *)alphaBackView{
    if (!_alphaBackView) {
        _alphaBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _alphaBackView.translatesAutoresizingMaskIntoConstraints = NO;
        _alphaBackView.backgroundColor = [UIColor blackColor];
        _alphaBackView.alpha = 0.0;
        _alphaBackView.userInteractionEnabled = YES;
        [_alphaBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)]];
    }
    return _alphaBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.alphaBackView];
    [self.view addSubview:self.containerView];
    
    
    [self addAlphaBgViewLayoutConstraint];
    [self addContainerViewLayoutConstraint];
    if (self.preferredStyle == XDZAlertControllerStyleAlert) {
        [self loadAlertStyleContainerView];
    }else{
        [self loadSheetStyleContainerView];
    }
}

/**
 添加灰色背景Layout
 */
- (void)addAlphaBgViewLayoutConstraint
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alphaBackView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alphaBackView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alphaBackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alphaBackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

#pragma mark --- ActionSheetStyle---Layout
- (void)addContainerViewLayoutConstraint
{
    if (self.preferredStyle == XDZAlertControllerStyleAlert) {
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_alertContentMaximumWidth]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }else{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:_sheetContentMargin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_sheetContentMargin]];
    containerTopConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:containerTopConstraint];
    }
}

- (void)loadSheetStyleContainerView
{
    UIView *cancelBgView;

    if (_cancelAction) {
        cancelBgView = [self verticalActionBackGroundViewWith:_cancelAction andSuperView:self.containerView];
        cancelBgView.layer.cornerRadius = _contentCornerRadius;
        cancelBgView.layer.masksToBounds = YES;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    UIView *otherBgView = [[UIView alloc] init];
    otherBgView.layer.cornerRadius = _contentCornerRadius;
    otherBgView.layer.masksToBounds = YES;
    otherBgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:otherBgView];

    if (cancelBgView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cancelBgView attribute:NSLayoutAttributeTop multiplier:1 constant:-XDZAlertVerticalSpace]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-XDZAlertVerticalSpace]];
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    UIView *titleBgView = [self titleAndMessageBackgroundViewAndSuperView:otherBgView];
    NSMutableArray *lineViews = [[NSMutableArray alloc] init];
    
    if (titleBgView) {
        if (_defaultActions.count) {
            UIView *splitLine = [self horizontalLineViewWithFrame:CGRectMake(0, 0, titleBgView.frame.size.width, 0.5)andSuperView:otherBgView];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:splitLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [lineViews addObject:splitLine];
        }else{
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        }
    }
    
    NSMutableArray *actionBGViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _defaultActions.count; i++) {
        UIView *actionBgView = [self verticalActionBackGroundViewWith:_defaultActions[i] andSuperView:otherBgView];
        
        [actionBGViews addObject:actionBgView];
        
        if (i == 0) {
            if (titleBgView) {
                UIView *firstLineView = lineViews[0];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:firstLineView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            }else{
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            }
        }else if (i<_defaultActions.count)
        {
            UIView *splitLine = [self horizontalLineViewWithFrame:CGRectMake(0,0, actionBgView.frame.size.width, 0.5) andSuperView:otherBgView];
            [lineViews addObject:splitLine];
            UIView *lastBgView = actionBGViews[i-1];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:splitLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:splitLine attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            if (i == _defaultActions.count - 1) {
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            }
        }
    }
    [self.view layoutIfNeeded];
}

- (UIView *)titleAndMessageBackgroundViewAndSuperView:(UIView *)superView
{
    if (!self.alertTitle.string.length && !self.message.string.length) {
        return nil;
    }
    UIView *titleBgView = [[UIView alloc] init];
    titleBgView.backgroundColor = [UIColor whiteColor];
    titleBgView.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:titleBgView];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = self.alertTitle;
    
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = self.message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [titleBgView addSubview:titleLabel];
    [titleBgView addSubview:messageLabel];
    
    if (!self.alertTitle.string.length) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTop multiplier:1 constant:self.titleMessageSpacing]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.titleMessageSpacing]];
        
    }else if (!self.message.string.length)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTop multiplier:1 constant:self.titleMessageSpacing]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.titleMessageSpacing]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_sheetContentMargin]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTop multiplier:1 constant:self.titleMessageSpacing]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_sheetContentMargin]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:self.titleMessageSpacing]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.titleMessageSpacing]];
    }
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];

    return titleBgView;
}

- (UIView *)verticalActionBackGroundViewWith:(XDZAlertAction *)action andSuperView:(UIView *)superView
{
    UIView *backView = [self actionBackgroundViewWithAction:action andSuperView:superView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.alertActionHeight]];
    
    return backView;
}


#pragma mark --- ActionAlertStyle---Layout
- (void)loadAlertStyleContainerView
{
    self.containerView.layer.cornerRadius = self.contentCornerRadius;
    self.containerView.layer.masksToBounds = YES;
    
    UIView *titleBgView = [self titleAndMessageBackgroundViewAndSuperView:self.containerView];
    
    if (_alertActions.count) {
        UIView *messageBottomLine;
        if (titleBgView) {
            messageBottomLine = [self horizontalLineViewWithFrame:CGRectZero andSuperView:self.containerView];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageBottomLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        }

        [self alert_loadOtherActionBackgroundViewWithTopView:messageBottomLine];
    }else{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
}

- (void)alert_loadOtherActionBackgroundViewWithTopView:(UIView *)messageBottomLine
{
    UIView *otherActionBgView = [[UIView alloc] init];
    otherActionBgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:otherActionBgView];
    
    if (messageBottomLine) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherActionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:messageBottomLine attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherActionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherActionBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherActionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:otherActionBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    if (_alertActions.count > 2) {
        
        NSMutableArray *bottomLines = [[NSMutableArray alloc] init];
        
        for (int i = 0; i< _defaultActions.count; i++) {
            
            UIView *actionBgView = [self actionBackgroundViewWithAction:_defaultActions[i] andSuperView:otherActionBgView];

            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];

            
            if (i == _defaultActions.count-1) {
                UIView *lastLine = bottomLines[i - 1];
                
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastLine attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                
                if (_cancelAction) {
                    
                    [bottomLines addObject:[self horizontalLineViewWithFrame:CGRectZero andSuperView:otherActionBgView]];
                    
                    UIView *cancelActionBgView = [self actionBackgroundViewWithAction:_cancelAction andSuperView:otherActionBgView];
                    
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
                    
                    UIView *nowLine = bottomLines[i];

                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nowLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                    
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nowLine attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                }else{
                  
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                }
            }else{
                
                [bottomLines addObject:[self horizontalLineViewWithFrame:CGRectZero andSuperView:otherActionBgView]];

                UIView *line = bottomLines[i];
                
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                
                if (i == 0) {
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                }else{
                    UIView *lastLine = bottomLines[i - 1];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastLine attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                }
            }
        }
    }else{
        
    UIView *splitLine;
    UIView *leftActionView;
    
    for (int i =0; i< _defaultActions.count; i++) {
     
        UIView *actionBgView = [self actionBackgroundViewWithAction:_defaultActions[i] andSuperView:otherActionBgView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

        if (i == 0) {
            leftActionView = actionBgView;
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            if (_alertActions.count>1) {
                splitLine = [self verticalLineWithSuperView:otherActionBgView];
                
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:splitLine attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
                
                if (_cancelAction) {
                    UIView *cancelActionBgView = [self actionBackgroundViewWithAction:_cancelAction andSuperView:otherActionBgView];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:splitLine attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelActionBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftActionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cancelActionBgView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                }
            }else{
                
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            }
        }else{
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:splitLine attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:otherActionBgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftActionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:actionBgView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        }
    }
    }
}






#pragma mark --- Public Method
- (UIView *)actionBackgroundViewWithAction:(XDZAlertAction *)action andSuperView:(UIView *)superView
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:backView];
    
    XDZActionButton *titleButton = [XDZActionButton buttonWithType:UIButtonTypeCustom];
    titleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [titleButton setAttributedTitle:action.title forState:UIControlStateNormal];
    titleButton.action = action;
    [titleButton addTarget:self action:@selector(titleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton addTarget:self action:@selector(titleButtonCancelTapped:) forControlEvents:UIControlEventTouchUpOutside];
    [titleButton addTarget:self action:@selector(titleButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [backView addSubview:titleButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    return backView;
}

/**
 horizontal split Line
 
 @param rect <#rect description#>
 @param superView <#superView description#>
 @return <#return value description#>
 */
- (UIView *)horizontalLineViewWithFrame:(CGRect)rect andSuperView:(UIView *)superView
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    [superView addSubview:line];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    return line;
}


/**
 垂直Line

 @param superView <#superView description#>
 @return <#return value description#>
 */
- (UIView *)verticalLineWithSuperView:(UIView *)superView
{
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    [superView addSubview:line];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
    return line;
}




- (void)titleButtonCancelTapped:(XDZActionButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
}

- (void)titleButtonHighlighted:(XDZActionButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.1];
}

- (void)titleButtonTapped:(XDZActionButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    sender.action.handler(sender.action);
    
    [self dismissSelf];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showContainerView];
}

- (void)showContainerView
{
    [self.view layoutIfNeeded];
    
    containerTopConstraint.constant = - self.containerView.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.alphaBackView.alpha = 0.4;
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissSelf
{
    if (self.preferredStyle == XDZAlertControllerStyleActionSheet) {
        containerTopConstraint.constant = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.alphaBackView.alpha = 0.0;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.alphaBackView.alpha = 0.0;
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
