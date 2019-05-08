//
//  GuideViewController.m
//  AnJaLi
//
//  Created by J雄zz on 2017/9/7.
//  Copyright © 2017年 J雄zz. All rights reserved.
//

#import "GuideViewController.h"
#import "BaseTabBarViewController.h"
#import "UserLabelViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate>
{
    // 创建页码控制器
    UIPageControl *pageControl;
    // 是否第一次进入引用
    BOOL flag;
}
@property (nonatomic,strong)UIButton *skipBtn;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray * imgArr = @[@"welcome",@"welcome2",@"welcome4",@"welcome5"];
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for (int i=0; i<imgArr.count; i++) {
        UIImage *image = kImage(imgArr[i]);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        // 在最后一页创建按钮
        if (i == imgArr.count - 1) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
//            [button setTitle:@"点击进入" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            button.layer.borderWidth = 1;
//            button.layer.cornerRadius = 5;
//            button.clipsToBounds = YES;
//            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imgArr.count, SCREEN_HEIGHT);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - SCREEN_HEIGHT / 32, SCREEN_HEIGHT * 15 / 16, SCREEN_WIDTH / imgArr.count, SCREEN_HEIGHT / 16)];
    // 设置页数
    pageControl.numberOfPages = imgArr.count;
    // 设置页码的点的颜色
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 设置当前页码的点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor dy_colorWithHex:0xBB17D3];
    
    [self.view addSubview:pageControl];
    
   
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算当前在第几页
    pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
    self.skipBtn.hidden = scrollView.contentOffset.x >= 3 * SCREEN_WIDTH ? NO: YES;
    
}

// 点击按钮保存数据并切换根视图控制器
- (void) go:(UIButton *)sender{
    flag = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:isFirstOpen];
    
    BaseTabBarViewController *baseVC = [BaseTabBarViewController sharedInstance];
    
    GET_AppDelegate.window.rootViewController = baseVC;
    
//    UserLabelViewController * userLabel = [[UserLabelViewController alloc]initWithNibName:@"UserLabelViewController" bundle:nil];
//
//
//    //模态出选择标签的界面
//    [self presentViewController:userLabel animated:YES completion:^{
//
//    }];

}

-(UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont fontWithName:PingFangSC_Light size:16];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipBtn.layer.borderWidth = 1;
        _skipBtn.layer.borderColor = Title999999.CGColor;
        _skipBtn.layer.cornerRadius = 15;
        _skipBtn.backgroundColor = [UIColor dy_colorWithHex:0x000000 alpha:.4];
        _skipBtn.clipsToBounds = YES;
        [_skipBtn addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:_skipBtn];
        [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(25);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
    }
    return _skipBtn;
}


@end
