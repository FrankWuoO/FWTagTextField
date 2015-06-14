//
//  FWTagTextField.h
//  FWTagTextField
//
//  Created by Wu Cheng-En on 2015/3/14.
//  Copyright (c) 2015年 Shacur. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FWTextField.h"

typedef enum {
    FWTextFieldStateEmpty = 0,
    FWTextFieldStateNormal= 1,
    FWTextFieldStateFull  = 2
} FWTextFieldState;

@protocol FWTagTextFieldDelegate <NSObject>
-(void)FWTagTextFieldDidTagCreated:(FWTextFieldState)state;
@optional
-(void)FWTagTextFieldDidBeginEditing;
-(void)FWTagTextFieldDidEndEditing;
@end

@interface FWTagTextField : UIControl

@property (strong,nonatomic) FWTextField *tagTextField;
@property (strong,nonatomic) NSMutableArray *tagItemArray;
@property (strong,nonatomic) UIColor *tagViewBackgroundColor;
@property (assign,nonatomic) unsigned int allowMaxTag;

@property(nonatomic) id<FWTagTextFieldDelegate> delegate;

- (instancetype)initWithView:(UIView *)view withFrame:(CGRect)frame;

@end