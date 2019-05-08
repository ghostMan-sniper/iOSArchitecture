
//
//  DWSplashVC.m
//  Yi
//
//  Created by iosdev on 2018/7/12.
//  Copyright © 2018年 J雄zz. All rights reserved.
//

#import "DWSplashVC.h"
#import "DY_GCDTimerManager.h"
#define timerName @"SplashViewControllerCountdown"

@interface DWSplashVC ()<NSURLConnectionDataDelegate>

@property (nonatomic,strong)UIImageView   *imageView;
@property (nonatomic,strong)UIImageView   *adView;
@property (nonatomic,strong)NSString      *imgUrl;
@property (nonatomic,strong)NSString      *jumpUrl;
@property (nonatomic,strong)UITapGestureRecognizer *gesture;

@property (nonatomic,strong)NSMutableData *recieveData;

@property (nonatomic,strong)NSDictionary *splashData;

@end

@implementation DWSplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.splashData = [UserDefaultHelper dictionaryForKey:UDKey_SplashData_Dict];
    
    //6SP
    NSString *launchSstr = @"启动页-iphone6s";
    //6
    if (SCREEN_WIDTH == 375){
        launchSstr = @"启动页-iphone6";
    }
    //5S
    if (SCREEN_WIDTH == 320){
        launchSstr = @"启动页-iphone5s";
    }
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:launchSstr]];
    self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    __block int time = 3;
    NSString *img = [self.splashData objectForKey:@"flickerLogoUrl"];
    NSString *imgURL = [img stringByAppendingString:KIMAGESIZE(SCREEN_WIDTH, SCREEN_HEIGHT)];
    _adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _adView.backgroundColor = [UIColor clearColor];
    _adView.contentMode = UIViewContentModeScaleAspectFill;
    _adView.alpha = 0;
    [_adView sd_setImageWithURL:imgURL.dw_URL placeholderImage:[UIImage imageWithContentsOfFile:launchSstr]];
    [self.view addSubview:self.adView];
    WS(weakSelf);
    [UIView animateWithDuration:1 animations:^{
        weakSelf.adView.alpha = 1;
    }];
    
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAd)];
    [self.adView setUserInteractionEnabled:YES];
    [self.adView addGestureRecognizer:self.gesture];
    
    //跳过广告
    CGFloat w = 80;
    CGFloat h = 34;
    CGFloat x = SCREEN_WIDTH - w - 15;
    CGFloat y = 40;
    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    goBtn.backgroundColor = KRGBACOLOR(0, 0, 0, .6);
    [goBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
    [goBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    goBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    goBtn.layer.cornerRadius = h/2;
    goBtn.layer.borderColor = KRGBACOLOR(255, 255, 255, 0.4).CGColor;
    goBtn.layer.borderWidth = 0.5;
    [goBtn addTarget:self action:@selector(jump) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:goBtn];
    goBtn.hidden = YES;
    

    [DYTimer dy_countDownWithName:timerName time:time action: ^(NSInteger time){
        goBtn.hidden = NO;
        NSString *strTime = [NSString stringWithFormat:@"%ld", (long)time];
        [goBtn setTitle:[NSString stringWithFormat:@"跳过  %@",strTime] forState:UIControlStateNormal];
    } endAction:^{
        [weakSelf jump];
    }];
}



- (void)jumpAd{
    [UserDefaultHelper saveStringValue:[self.splashData objectForKey:@"flickerUrl"] key:KUserDefaultOpenAD];
    [self jump];
}

- (void)jump{
    [DYTimer dy_cancelTimerWithName:timerName];
    //设置根视图控制器

        GET_AppDelegate.window.rootViewController = [BaseTabBarViewController sharedInstance];
        [GET_AppDelegate.window makeKeyAndVisible];
    
}

- (void)getImageHeightWithUrl:(NSString*)url {

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *image     = [UIImage imageWithData:data];

        self.adView.image = image;

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
