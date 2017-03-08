//
//  XDZAlertController.h
//  XDZAlertDemo
//
//  Created by bestkai on 2017/2/7.
//  Copyright © 2017年 bestkai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XDZAlertActionStyleDefault,
    XDZAlertActionStyleCancel,
} XDZAlertActionStyle;


typedef enum : NSUInteger {
    XDZAlertControllerStyleActionSheet,
    XDZAlertControllerStyleAlert,

} XDZAlertControllerStyle;


@interface XDZAlertAction : NSObject

@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, assign) XDZAlertActionStyle style;
@property (nonatomic,  copy) void (^handler) (XDZAlertAction *action);


+ (instancetype) actionWithTitle:(NSAttributedString *)title style:(XDZAlertActionStyle)style handler:(void(^)(XDZAlertAction *action))handler;

@end


@interface XDZActionButton : UIButton

@property (nonatomic,strong) XDZAlertAction *action;

@end


@interface XDZAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSAttributedString *)alertTitle message:(NSAttributedString *)message preferredStyle:(XDZAlertControllerStyle)preferredStyle;

- (void)addAcion:(XDZAlertAction *)action;

@property (nonatomic, strong) NSArray<XDZAlertAction *> *actions;

@property (nonatomic, copy) NSAttributedString *alertTitle;
@property (nonatomic, copy) NSAttributedString *message;

@property (nonatomic, assign) XDZAlertControllerStyle preferredStyle;

//SheetStyle


/**
 Corner radius
 */
@property (nonatomic,assign) CGFloat contentCornerRadius;
@property (nonatomic,assign) CGFloat sheetContentMargin;
@property (nonatomic,assign) CGFloat titleMessageSpacing;
@property (nonatomic,assign) CGFloat alertActionHeight;


@property (nonatomic,assign) CGFloat alertContentMaximumWidth;

@end
