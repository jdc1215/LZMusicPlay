//
//  LZMusicDetailVIewController.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/22.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZMusicDetailVIewController.h"
#import "ZCircleSlider.h"
@interface LZMusicDetailVIewController ()
@property (nonatomic, strong) ZCircleSlider *circleSlider;
@end

@implementation LZMusicDetailVIewController
#pragma mark - action

- (IBAction)circleSliderTouchDown:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    
}

- (IBAction)circleSliderValueChanging:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
//    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 100];
//    self.progressSlider.value = slider.value;
}

- (IBAction)circleSliderValueDidChanged:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
//    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 100];
}

- (IBAction)progressSliderValueChanging:(UISlider *)slider {
//    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 100];
    self.circleSlider.value = slider.value;
}

- (IBAction)progressSliderValueDidChanged:(UISlider *)slider {
//    self.progressSlider.value = slider.value;
//    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 100];
}
- (ZCircleSlider *)circleSlider {
    if (!_circleSlider) {
        _circleSlider = [[ZCircleSlider alloc] initWithFrame:CGRectMake((LZSCREENW - 320) / 2.0-2, self.songIcon.frame.origin.y-10, 320, 320)];
        _circleSlider.minimumTrackTintColor = [UIColor blueColor];
        _circleSlider.maximumTrackTintColor = [UIColor redColor];
        _circleSlider.backgroundTintColor = [UIColor colorWithWhite:0 alpha:0.2];
        _circleSlider.circleBorderWidth = 5.0f;
        _circleSlider.thumbRadius = 6;
        _circleSlider.thumbExpandRadius = 12.5;
        _circleSlider.thumbTintColor = [UIColor redColor];
        _circleSlider.circleRadius = 300 / 2.0 + 2;
        _circleSlider.value = 0;
        _circleSlider.loadProgress = 0;
        _circleSlider.canRepeat = NO;
        [_circleSlider addTarget:self
                          action:@selector(circleSliderTouchDown:)
                forControlEvents:UIControlEventTouchDown];
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueChanging:)
                forControlEvents:UIControlEventValueChanged];
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueDidChanged:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleSlider;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([LZPlayerBottomView lzPlayerBottomView].isSinglecycle) {
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycleSel"] forState:UIControlStateNormal];
    }else{
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycle1"] forState:UIControlStateNormal];
    }
    [self initData];
    [self.view addSubview:self.circleSlider];
}
#pragma mark 初始化
-(void)initData{
    self.songIcon.layer.cornerRadius = 150;
    self.songIcon.layer.masksToBounds = YES;
    [HealpClass blurEffrct:self.bgImageVIew];
    self.sliderProgress.minimumTrackTintColor = [UIColor colorWithRed:255 / 255.0 green:209 / 255.0 blue:2 / 255.0 alpha:1.0];
    [self.sliderProgress setThumbImage:[UIImage imageNamed:@"icon_point1"] forState:UIControlStateNormal];
    NSTimer *timer =[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)timerAct{
  
    UIImage *image = [LZPlayerBottomView lzPlayerBottomView].headerIV.image;
    self.songIcon.image = image;
    self.bgImageVIew.image = image;
   
    self.songLB.text = [NSString stringWithFormat:@"%@",[LZPlayerBottomView lzPlayerBottomView].songNameLB.text];
    self.songerLB.text = [NSString stringWithFormat:@"-- %@ --",[LZPlayerBottomView lzPlayerBottomView].songerLB.text];
    NSString *time = [NSString stringWithFormat:@"%@",LZUserDefaultsGET(TOTALTIME)];
    self.totalTimeLB.text = [NSString stringWithFormat:@"%02ld:%02ld", [time integerValue] / 60, [time integerValue] % 60];;
    self.sliderProgress.maximumValue =[time doubleValue];
    long long int currentTime = [LZPlayerManager lzPlayerManager].player.currentTime.value / [LZPlayerManager lzPlayerManager].player.currentTime.timescale;
    self.currentTimeLB.text = [NSString stringWithFormat:@"%02lld:%02lld", currentTime / 60, currentTime % 60];
    self.sliderProgress.minimumValue = 0;
    self.sliderProgress.value = currentTime;//当前播放进度
    
    if (self.sliderProgress.value == [time integerValue]) {//如果progressSlider的值=总时长 就直接下一首
        [[LZPlayerBottomView lzPlayerBottomView] autoNext];
    }
    if ([LZPlayerManager lzPlayerManager].isPlay) {//正在播放歌曲时头像转动
        [UIView beginAnimations:@"rzoration" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.songIcon.transform = CGAffineTransformRotate(self.songIcon.transform, 0.02);
        [UIView commitAnimations];
    }
}
//返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sliderProgress:(id)sender {
    [[LZPlayerManager lzPlayerManager]playerProgressWithProgressFloat:((UISlider*)sender).value];
}
//上一首
- (IBAction)previous:(id)sender {
    [[LZPlayerBottomView lzPlayerBottomView] previousBtnClicked:sender];
}
//播放暂停
- (IBAction)playAndPause:(id)sender {
    [[LZPlayerBottomView lzPlayerBottomView] playAndPauseBtnClicekd:sender];
}
//下一首
- (IBAction)nextAction:(id)sender {
    [[LZPlayerBottomView lzPlayerBottomView] nextBtnClicked:sender];
}
//单曲循环
- (IBAction)singlecycle:(UIButton *)sender {

    if ([LZPlayerBottomView lzPlayerBottomView].isSinglecycle) {
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycle1"] forState:UIControlStateNormal];
    }else{
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycleSel"] forState:UIControlStateNormal];
    }
    [LZPlayerBottomView lzPlayerBottomView].isSinglecycle = ![LZPlayerBottomView lzPlayerBottomView].isSinglecycle;
}

@end
