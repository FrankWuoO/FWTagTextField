//
//  FWTagTextField.m
//  FWTagTextField
//
//  Created by Wu Cheng-En on 2015/3/14.
//  Copyright (c) 2015年 Shacur. All rights reserved.
//

#import "FWTagTextField.h"

@interface FWTagTextField()<UITextFieldDelegate>{
    CGFloat tagViewMargin;
}
@end

@implementation FWTagTextField

static int FWTagViewTag = 1;

- (instancetype)initWithView:(UIView *)view withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariable];
        [self initLayout:frame];
    }
    return self;
}

-(void)initVariable{
    _tagItemArray =[NSMutableArray array];
    tagViewMargin = 5;
    _allowMaxTag = 4;
    
}

-(void)initLayout:(CGRect)frame{
    _tagTextField = [[FWTextField alloc]init];
    _tagTextField.frame = CGRectMake(2.5, 2.5, frame.size.width-5, frame.size.height-5);
    _tagTextField.delegate = self;
    _tagTextField.returnKeyType = UIReturnKeyJoin;
    _tagTextField.borderStyle = UITextBorderStyleRoundedRect;
    _tagTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _tagTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tagTextField.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    _tagTextField.preservesSuperviewLayoutMargins = YES;
    [self addSubview:_tagTextField];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(FWTagTextFieldDidBeginEditing)]) {
        [self.delegate FWTagTextFieldDidBeginEditing];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(FWTagTextFieldDidEndEditing)]) {
        [self.delegate FWTagTextFieldDidEndEditing];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]&&![textField.text isEqualToString:@" "]&&_tagItemArray.count<_allowMaxTag){
        [self.delegate FWTagTextFieldDidTagCreated:FWTextFieldStateNormal];
        [self addTagTextLabelViewWithTextField:textField];
    }
    else if (![textField.text isEqualToString:@""]&&_tagItemArray.count >=_allowMaxTag){
        [self.delegate FWTagTextFieldDidTagCreated:FWTextFieldStateFull];
        NSLog(@"\nToo much!!");
    }
    else{
        [self.delegate FWTagTextFieldDidTagCreated:FWTextFieldStateEmpty];
        NSLog(@"\nNo Text Here!!");
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string {
    
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = [string isEqualToString:@""] && [resultString isEqualToString:@""] && range.location == 0 && range.length == 0;
    
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        if (_tagItemArray.count>0) {
            [self deleteTagTextLabelView];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self clearAllTagView];
    return YES;
}

-(void)addTagTextLabelViewWithTextField:(UITextField *)textField{
    UIView *tagView = [[UIView alloc]init];
    tagView.layer.cornerRadius = 6;
    if (_tagViewBackgroundColor != nil) {
        tagView.backgroundColor = _tagViewBackgroundColor;
    }
    else{
        tagView.backgroundColor =[UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
    }
    tagView.tag = FWTagViewTag;
    
    UILabel *tagLabel = [[UILabel alloc]init];
    tagLabel.text = _tagTextField.text;
    tagLabel.textColor = [UIColor whiteColor];
    [tagLabel sizeToFit];
    tagLabel.frame =CGRectOffset(tagLabel.frame, 1, 0.5);
    [tagView addSubview:tagLabel];
    
    tagView.frame = CGRectMake(_tagTextField.dx, 5, tagLabel.frame.size.width+5, tagLabel.frame.size.height+2);
    [_tagItemArray addObject:tagView];
    
    _tagTextField.dx = CGRectGetMaxX(tagView.frame)+tagViewMargin;
    [textField addSubview:tagView];
    
    textField.text = @"";
    FWTagViewTag+=1;
}

-(void)deleteTagTextLabelView{
    UIView *tagView = _tagItemArray.lastObject;
    CGFloat x = tagView.frame.size.width;
    [UIView animateWithDuration:0.5
                     animations:^(){
                         tagView.transform =CGAffineTransformScale(tagView.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finish){
                         if (finish) {
                             _tagTextField.dx = _tagTextField.dx - x -tagViewMargin;
                             [tagView removeFromSuperview];
                             if(_tagItemArray.count!=0){
                                 [_tagItemArray removeObjectAtIndex:_tagItemArray.count-1];
                             }
                         }
                     }
     ];
}

-(void)clearAllTagView{
    for (id tagView in _tagTextField.subviews) {
        if ([tagView isMemberOfClass:[UIView class]]) {
            [tagView removeFromSuperview];
            [_tagItemArray removeObjectAtIndex:_tagItemArray.count-1];
        }
    }
    _tagTextField.dx = 5;
}

@end