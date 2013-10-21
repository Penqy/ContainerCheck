//
//  HomeViewController.m
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import "HomeViewController.h"
#import "MLNavigationController.h"
#import "CheckViewController.h"
#import "MoreViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //抽检计划页面
    CheckViewController *checkView = [[CheckViewController alloc] initWithNibName:@"CheckViewController" bundle:nil];
    UITabBarItem *checkItem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:1];
    checkView.tabBarItem = checkItem;
    MLNavigationController *checkNav = [[MLNavigationController alloc]initWithRootViewController:checkView];
    checkNav.navigationBar.barStyle = UIBarStyleBlack;
    
    //更多页面
    MoreViewController *moreView = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:1];
    moreView.tabBarItem = moreItem;
    MLNavigationController *moreNav = [[MLNavigationController alloc]initWithRootViewController:moreView];
    moreNav.navigationBar.barStyle = UIBarStyleBlack;
    
    
    //加入views数组
    NSArray *viewControllers = @[checkNav, moreNav];
    [self setViewControllers:viewControllers animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
