//
//  ViewController.m
//  GuessPicture
//
//  Created by Fu on 2017/7/21.
//  Copyright © 2017年 Fu. All rights reserved.
//

#import "ViewController.h"
#import "OptionModel.h"
#import "OptionView.h"

// 设置一些常量
#define kButtonWidth 30
#define kMargin 10
#define kViewSize (self.view.frame.size)

@interface ViewController ()

#pragma mark - UI 变量
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UIButton *hitBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet OptionView *optionView;

@property (strong, nonatomic) UIView *coverView;


#pragma mark - 逻辑变量
@property (nonatomic, assign) NSInteger index; //当前题号

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

// 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        // 从 plist 文件中读取数据
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];

        // 把数组中的字典转化为自定义的数据模型
        for (NSDictionary *dic in arr) {
            [_dataArray addObject:[OptionModel optionModelWithDict:dic]];
        }
    }
    
//    NSLog(@"%@", _dataArray);
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 1; // 设置初始值
    
    [self.optionView setupOptionView]; // 不需要每次更新都重新绘制，答案区域则需要，因为答案字数不确定
    
    [self setupCoverView];
    
    [self updateUI];
}

#pragma mark - UI 设置
// 遮罩
-(void)setupCoverView{
    _coverView = [[UIView alloc]initWithFrame:self.view.frame];
    
    [_coverView setBackgroundColor:[UIColor blackColor]];

    _coverView.alpha = 0;
    
    [self.view addSubview:_coverView];
}

-(void)updateUI{
    // 给 storyboard 中的系列元素赋值
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_index, self.dataArray.count];
    
    OptionModel *model = self.dataArray[_index - 1];
    _titleLabel.text = model.title;
    [_image setImage:[UIImage imageNamed:model.icon]];
    [_image setUserInteractionEnabled:YES];
    [_image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg)]];
    
    NSInteger length = model.answer.length;
    
    // 设置答案区域
    [self setupAnswerView:length];
    
    // 设置选项区域
    [self.optionView updateOptionViewBtns:model.options];
}

-(void)setupAnswerView:(NSInteger)count{
    // 按钮的宽度
    CGFloat btnWidth = count * kButtonWidth + (count -1) * kMargin;
    // 计算起始 x 值
    CGFloat startX = (kViewSize.width - btnWidth) / 2;
    
    // 先移除之前添加的子view
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 根据数量绘制方格
    for (int i = 0; i < count; i++) {
        CGRect frame =  CGRectMake( startX + i*kButtonWidth + i*kMargin, 0, kButtonWidth, kButtonWidth);
        UIButton *btn = [self buttonWithFrame:frame normalImg:@"btn_answer" andHighlightImg:@"btn_answer_highlighted"];

        [btn addTarget:self action:@selector(didClickAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.answerView addSubview:btn];
    }
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


#pragma mark - 答案点击事件响应
-(void)didClickAnswerButton:(UIButton *)sender{
    // 如果不为空，清除内容，重新显示在选项区域
    if (sender.currentTitle.length == 0) return;
    
    self.optionView.userInteractionEnabled = YES;
    
    [self.optionView recoverOptionBtn:sender];
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    
    [self updateAnswerColorToRed:NO];
    
}



#pragma mark - 选项点击事件响应
-(void)didClickOptionButton:(UIButton *)sender{
    // 取出文字，隐藏button
    NSString *title = sender.currentTitle;
    sender.hidden = YES;
    
    // 在答案区域显示出来
    [self.answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if (btn.currentTitle.length == 0) {
            [btn setTitle:title forState:UIControlStateNormal];
            *stop = YES;
        }
    }];
    
    // 判断答案区域是否已全部显示了文字
    if ([self answerIsComplete]) {
        // 禁用交互
        self.optionView.userInteractionEnabled = NO;
        
        [self checkAnswerIsRight];
    }
}

// 判断答案区域是否已全部显示了文字
-(BOOL)answerIsComplete{
    __block BOOL isComplete = YES;
    [self.answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if(btn.currentTitle.length == 0){
            isComplete = NO;
            *stop = YES;
        }
    }];
    
    return isComplete;
}

// 判断答案区域是否已全部显示了文字
-(void)checkAnswerIsRight{
    // 获取正确答案
    OptionModel *model = self.dataArray[_index - 1];
    NSString *answer = model.answer;
    
    // 获取用户输入的答案
    __block NSString *userAnswer = @"";
    [self.answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        userAnswer = [userAnswer stringByAppendingString:btn.currentTitle];
    }];
    
    // 比较
    if ([answer isEqualToString:userAnswer]) {
        // 回答正确，增加金币，切换到下一题
        [self updateCoinNumWith:YES];
        
        [self performSelector:@selector(next) withObject:nil afterDelay:1];
        
    }else{
        // 回答错误，减少金币，字体变红
        [self updateCoinNumWith:NO];
        
        [self updateAnswerColorToRed:YES];
    }
}

// 修改金币数量
-(void)updateCoinNumWith:(BOOL)isAdd{
    NSInteger currentCoin = [self.coinBtn.currentTitle integerValue];
    
    if (isAdd == YES) {
        currentCoin += 100;
    }else{
        currentCoin -= 1000;
        // 没钱了
        if(currentCoin < 0){
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"没钱啦" message:@"去充钱吧" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertCtrl animated:YES completion:nil];
            return;
        }
    }
    
    [self.coinBtn setTitle:[NSString stringWithFormat:@"%ld", currentCoin] forState:UIControlStateNormal];
}

// 将答案区字体变红
-(void)updateAnswerColorToRed:(BOOL)isRed{
    UIColor *color = isRed ? [UIColor redColor] : [UIColor blackColor];
    [self.answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn setTitleColor:color forState:UIControlStateNormal];
    }];
}

// 进入下一题
-(void)next{
    // 如果没有下一题了
    if (_index == self.dataArray.count) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"you win" message:@"perfect!" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"yes~" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _index = 0;
            
            [self next];// 重头开始
        }]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
        return;
    }
    
    _index++;
    [self updateUI];
    
    self.nextBtn.enabled = (_index != self.dataArray.count)?YES:NO;
    self.optionView.userInteractionEnabled = YES;
    [self.optionView showAllOptionButton];
}

#pragma mark - 四个按钮点击事件
- (IBAction)didClickHitButton:(UIButton *)sender {
    // 清空答案区域的答案，回复选项区的答案
    [self.answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if (![btn.currentTitle isEqualToString:@""]) {
            [self.optionView recoverOptionBtn:btn];
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
    }];
    // 获取正确答案
    OptionModel *model = self.dataArray[_index - 1];
    NSString *firstAnswer = [model.answer substringWithRange:NSMakeRange(0, 1)]; // substringByIndex
    // 显示正确答案第一个字
    UIButton *firstBtn = [self.answerView.subviews firstObject];
    [firstBtn setTitle:firstAnswer forState:UIControlStateNormal];
    [self.optionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if ([btn.currentTitle isEqualToString:firstAnswer]) {
            btn.hidden = YES;
            *stop = YES;
        }
    }];
    
    [self updateCoinNumWith:NO]; // 减少金币
    [self updateAnswerColorToRed:NO]; // 如果字体变红了，需要变回来
}

- (IBAction)didClickHelpButton:(UIButton *)sender {
}

- (IBAction)didClickBigPicButton:(UIButton *)sender {
    [self showCoverViewWith:YES];
}

-(void)showCoverViewWith:(BOOL)show{
    CGFloat delta = show ? 0.6 : 0;
    CGAffineTransform transform = show ? CGAffineTransformMakeScale(1.5, 1.5) : CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = delta;
        _image.transform = transform;
    }];
    
    if (show) {
        [self.view bringSubviewToFront:_image];
    }
}

- (IBAction)didClickNextButton:(UIButton *)sender {
    [self next];
}

-(void)clickImg{
    [self showCoverViewWith:(_coverView.alpha == 0)?YES:NO];
}

@end
