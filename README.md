# GuessPicture
itcast 教程，练习项目

## 项目：看图猜词
项目地址： 
项目来源：ITcast 初级教程 UI 基础

需求分析：
1. UI 显示
2. 数据载入
3. 猜词逻辑

## UI 显示
1. 信息显示区域
	四个按钮：提示、大图、帮助、下一题
	三个Label：第几题、题目描述、金币数量
	一张图
2. 答案区域
	根据答案字数显示几个空白 view
3. 选项区域
	3 x 7 个选项

## 数据载入
从 plist 载入数据

## 猜词逻辑
1.  点击选项区域：
	选项区域按钮消失
	答案区域第一个为空的按钮显示已选答案字
2. 点击已填答案区域：
	清空字
	字回到选项区域
3. 输入完成，判断正确与否：
	错误：字变红，可以继续做题，减 1000 金币
	正确：禁用选项区域，1s 后切换下一题，加 100 金币
4. 提示按钮：
	点击后，清空答案区域，现实答案第一个字
	减 100 金币
5. 大图按钮：
	点击后，出现半透明灰色遮罩，同时放大图片
6. 下一题按钮：
	切换数据
	当没有下一题，需要禁用按钮

## 时长用时：一个页面，有一定的逻辑判断，4h左右

tip：
左缩进：command + \[
右缩进：command + \]

## 代码知识点
1. 懒加载：存储数据的数组，当数据为空时，才从 plist 读取数据，否则直接返回数组
2. 给 UIImageView 添加点击事件：添加手势消息

        [_image addGestureRecognizer:[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImg)]];

3. 如果禁用了父 View 的交互，子View 也无法进行交互：userInteractionEnabled

4. 使用 block 进行迭代：enumerateObjectsUsingBlock

5. button 的当前 title：btn.currentTitle

6. 警告框：UIAlertController 的用法

	    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"没钱啦" message:@"去充钱吧" preferredStyle:UIAlertControllerStyleAlert];
	    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
	    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
	    [self presentViewController:alertCtrl animated:YES completion:nil];

7. 使用 transform 进行缩放变形动画：

	    CGFloat delta = show ? 0.6 : 0;
	    CGAffineTransform transform = show ? CGAffineTransformMakeScale(1.5, 1.5) : CGAffineTransformIdentity;
	
	    [UIView animateWithDuration:0.5 animations:^{
		    _coverView.alpha = delta;
		    _image.transform = transform;
	    }];
8. 九宫格布局的坐标计算：i % column 和 i / column
9. 从 plist 中读取数据
	    // 从 plist 文件中读取数据
	    NSArray *arr = [NSArray arrayWithContentsOfFile:[NSBundle mainBundle pathForResource:@"questions.plist" ofType:nil]];

	    // 把数组中的字典转化为自定义的数据模型
	    for (NSDictionary *dic in arr) {
		    [_dataArray addObject:[OptionModel optionModelWithDict:dic]];
	    }
10. 利用 kvc 将字典赋值给自定义数据模型：setValuesForKeysWithDictionary
