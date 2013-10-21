//
//  CheckViewController.h
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "REMenu.h"

@interface CheckViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    
    NSTimer *_timer;
    BOOL setting;
}


@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) REMenu *menu;

@property (strong, nonatomic) IBOutlet UIView *pushView;
@property (strong, nonatomic) IBOutlet UILabel *pushLabel;






//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;
@end
