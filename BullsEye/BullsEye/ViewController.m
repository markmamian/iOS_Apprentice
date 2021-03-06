//
//  ViewController.m
//  BullsEye
//
//  Created by Mark MaMian on 16/7/29.
//  Copyright © 2016年 Mark MaMian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    int _currentValue;
    int _targetValue;   //声明
    int _score;
    int _round;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startNewGame];  
    
    [self updateLabels];
    
    //   以下为更高级的控制图片的代码，更改slider的属性
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];   //更改slider的中间的点
    
    UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.slider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];  //同样的，也是更改slider中间的点，目的是替换图像，这个为党用户点击中了圆点时替换。作用是更改透明度 setThumbImage 里的 forState属性不同，一个是Normal 一个是Highlighted  一个是正常状态下，一个是当用户点击时。

    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
      //更改状态条的显示    实际上是以两个图像的显示代替的，  左边一个，邮编一个
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];

    UIImage *trackRightImage =[[UIImage imageNamed:@"SliderTrackRight"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
    
    
    
    
    
    
    
    
    
    
    
}

- (void)startNewRound{
    _round += 1;
    _currentValue = self.slider.value;   //赋初值
    _currentValue = 50;
    _targetValue = 1 + arc4random_uniform(100);  //1-100
    
}

- (IBAction)showAlert{   //下面的方法已经过时。
    int differece = abs(_targetValue - _currentValue);  //当前用户的值-随机值
    int points = 100 - differece;
    _score += points;
    NSString *title;
    if (differece == 0) {
        title = @"Perfect";
        points += 100;   //奖励点数
    }else if (differece < 5) {
        title = @"You almost had it!";
        if (differece == 1) {
            points += 50;
        }
    } else if (differece < 10) {
        title = @"Pretty good!";
    } else {
        title = @"Not even close...";
    }
    _score += points;

    
    NSString *message = [NSString stringWithFormat:@"You scored %d points", points];   //定义了一个NSSting指针变量的值
    UIAlertView *alertView =    [[UIAlertView alloc] //创建
  initWithTitle:title   //弹出信息标题
  message:message    //弹出信息内容
  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];   //Awesome为按钮名称
    [alertView show]; //调用代码
    [self startNewRound];   //每次弹出窗口后重新调用，产生随机数
    [self updateLabels];
}

- (IBAction)sliderMoved:(UISlider *)slider{  //当slider移动时输出
    //NSLog(@"The value of the slider is now: %f",slider.value);
    //输出slider的值
    _currentValue = round(slider.value);   //int   lround = long
}

- (IBAction)startOver{    //点击OVER按钮时 清零
  
       //当按钮被按下时，增加渐进动画效果
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //
    [self startNewGame];
    [self updateLabels];
    //
    [self.view.layer addAnimation:transition forKey:nil];
    
    
    
    
    
}

- (void)updateLabels{
    self.targetlabel.text = [NSString stringWithFormat:@"%d",_targetValue];//让label的值等于NSSting
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",_score];
    
    self.roundLabel.text = [NSString stringWithFormat:@"%d",_round];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //这里表示当alertView消息的时候运行的 代码 
    //[self startNewRound];   //这里重复了    BUG！！！！  调用alertView重复了
    [self updateLabels];   //This is the delegate method that is called by the alert view when the user closes it. When you get this message it basically says: “Hi, delegate. The alert view so-and- so was dismissed because the user pressed such-and-such button.” Your alert view only has one button but for an alert with multiple buttons you’d look at the buttonIndex parameter to figure out which button was pressed. In response to the alert view closing, you start the new round.
}

- (void)startNewGame{
    _score = 0;
    _round = 0;
    [self startNewRound];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
