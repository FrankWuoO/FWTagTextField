//
//  ViewController.m
//  FWTagTextField
//
//  Created by Wu Cheng-En on 2015/3/14.
//  Copyright (c) 2015年 Shacur. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FWTagTextField.h"
@interface ViewController()<UITextFieldDelegate,FWTagTextFieldDelegate>{
    UISlider *sliderView;
    UILabel *countLabel;
    UILabel *warningLabel;
    FWTagTextField *inputTextField;
}
@end

@implementation ViewController

-(void)viewDidLoad{
    [self initLayout];
}
-(void)initLayout{
    
    UILabel *allowTagViewCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 130, 35)];
    allowTagViewCountLabel.text = @"Set tag limit：";
    [self.view addSubview:allowTagViewCountLabel];
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(allowTagViewCountLabel.frame)+50, 57, 30, 35)];
    countLabel.text = @"1";
    countLabel.font = [UIFont boldSystemFontOfSize:24.0];
    [self.view addSubview:countLabel];
    
    sliderView = [[UISlider alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(allowTagViewCountLabel.frame)+20, 200, 30)];
    sliderView.minimumValue = 1;
    sliderView.maximumValue = 5;
    [sliderView addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderView];
    
    warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, CGRectGetMaxY(sliderView.frame), 150, 30)];
    warningLabel.center = CGPointMake(self.view.center.x,CGRectGetMaxY(sliderView.frame)+ warningLabel.frame.size.height/2+5);
    warningLabel.text = @"Input Tag";
    warningLabel.textColor = [UIColor redColor];
    warningLabel.font = [UIFont boldSystemFontOfSize:12.0];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:warningLabel];
    
    inputTextField = [[FWTagTextField alloc]initWithView:self.view withFrame:CGRectMake(30, 180, 260, 40)];
    inputTextField.allowMaxTag = sliderView.value;
    inputTextField.delegate = self;
    [self.view addSubview:inputTextField];
    
}
-(void)changeValue:(UISlider *)slider{
    int maxTagLimit = (int)[slider value];
    countLabel.text = [NSString stringWithFormat:@"%d",maxTagLimit];
    inputTextField.allowMaxTag = maxTagLimit;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.view isExclusiveTouch]) {
        [inputTextField.tagTextField resignFirstResponder];
    }
}
#pragma mark - Delegate Method
-(void)FWTagTextFieldDidTagCreated:(FWTextFieldState)state{
    switch (state) {
        case FWTextFieldStateEmpty:
            warningLabel.text = @"Empty Tag";
            break;
        case FWTextFieldStateNormal:
            warningLabel.text = @"Input Tag";
            break;
        case FWTextFieldStateFull:
            warningLabel.text = @"Upper limit";
            break;
        default:
            break;
    }
}
@end