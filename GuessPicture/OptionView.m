//
//  OptionView.m
//  GuessPicture
//
//  Created by Fu on 2017/7/22.
//  Copyright © 2017年 Fu. All rights reserved.
//

#import "OptionView.h"

// 设置一些常量
#define kButtonWidth 30
#define kMargin 10
#define kViewSize (self.frame.size)

@implementation OptionView

-(void)setupOptionView{
    // 每行个数是固定的
    int column = 7;
    CGFloat margin = (kViewSize.width - column * kButtonWidth) / (column + 1);
    
    for (int i=0; i < 21; i++) {
        CGFloat startX = ( i % column + 1) * margin + (i % column) * kButtonWidth;
        CGFloat startY = ( i / column) * margin + (i / column) * kButtonWidth;
        
        CGRect frame = CGRectMake(startX, startY, kButtonWidth, kButtonWidth);
        UIButton *btn = [self buttonWithFrame:frame normalImg:@"btn_option" andHighlightImg:@"btn_option_highlighted"];
        
        [btn addTarget:self action:@selector(didClickOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

-(void)updateOptionViewBtns:(NSArray *)arr{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn setTitle:arr[idx] forState:UIControlStateNormal];
    }];
}

// 根据答案按钮，恢复对应的选项区按钮
-(void)recoverOptionBtn:(UIButton *)answerBtn{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if ([btn.currentTitle isEqualToString:answerBtn.currentTitle]) {
            btn.hidden = NO;
            *stop = YES;
        }
    }];
}

-(void)showAllOptionButton{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.hidden = NO;
    }];
}

#pragma mark - 返回一个按钮
-(UIButton *)buttonWithFrame:(CGRect)frame normalImg:(NSString *)normal andHighlightImg:(NSString *)highlight{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // 设置按钮字体为黑色
    
    return btn;
}

@end
