//
//  FWTextField.m
//  FWTagTextField
//
//  Created by Wu Cheng-En on 2015/3/14.
//  Copyright (c) 2015年 Shacur. All rights reserved.
//
#import "FWTextField.h"

@implementation FWTextField
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderStyle = UITextBorderStyleRoundedRect;
        _dx = 5.0;
        _dy = 5.0;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake( _dx, _dy, bounds.size.width-_dx, bounds.size.height);
    return rect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = CGRectMake( _dx, _dy, bounds.size.width-_dx, bounds.size.height);
    return rect;
}

- (void)deleteBackward {
    BOOL shouldDismiss = [self.text length] == 0;
    [super deleteBackward];
    if (shouldDismiss) {
        if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
        }
    }
}

- (BOOL)keyboardInputShouldDelete:(UITextField *)textField {
    BOOL shouldDelete = YES;
    
    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];
        
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }
    
    if (![textField.text length] && [[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
        [self deleteBackward];
    }
    
    return shouldDelete;
}
@end