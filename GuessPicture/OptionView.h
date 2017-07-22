//
//  OptionView.h
//  GuessPicture
//
//  Created by Fu on 2017/7/22.
//  Copyright © 2017年 Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionView : UIView

-(void)setupOptionView;

-(void)updateOptionViewBtns:(NSArray *)arr;

-(void)recoverOptionBtn:(UIButton *)answerBtn;

-(void)showAllOptionButton;

@end
