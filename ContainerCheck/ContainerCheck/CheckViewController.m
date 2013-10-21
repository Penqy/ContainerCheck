//
//  CheckViewController.m
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#define UP          @"UP"
#define DOWM        @"DOWN"

#import "CheckViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "CheckCell.h"
#import "CheckDetailViewController.h"
#import "Utility.h"
#import <AVFoundation/AVFoundation.h>
#import "PlanInfo.h"

@interface CheckViewController (){
//    int count;
}

@end

@implementation CheckViewController
@synthesize myTableView;
@synthesize pushView;
@synthesize pushLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"抽检";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initRefreshHeadTable];
    [self initREMenuItem];
    [self initBottomPushView];
    [self initPhotoPlist];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    if ([SharedModel getInstance].photosList.count > 0) {
        if(_timer == nil){
            [self openNSThread];
        }
    }
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [_timer invalidate];
    _timer = nil;
    [self moveBottomPushView:DOWM];
    setting = YES;//手电设置
}

#pragma mark  - 下拉刷新
- (void)initRefreshHeadTable{
    if (_refreshTableView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        view.delegate = self;
        [self.myTableView addSubview:view];
        _refreshTableView = view;
    }
    [_refreshTableView refreshLastUpdatedDate];
}
//开始加载
- (void)reloadTableViewDataSource{
    //刷新  重新获取列表数据
    _reloading = YES;
//    [Dialog progressToast:@"计划刷新"];
    if ([Utility getCheckPlan]) {
        [Dialog simpleToast:@"加载完成"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请求错误!"];
    }
    
}
//加载完成
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];

    [myTableView reloadData];

    
    //发出声音
    //    AudioServicesPlaySystemSound(soundID);
    //    NSLog(@"doneLoadingTableViewDatadoneLoadingTableViewData");
    
}

//点击出现下拉刷新效果
-(void) ViewFrashData{
    [myTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}
-(void)doneManualRefresh{
    [_refreshTableView egoRefreshScrollViewDidScroll:myTableView];
    [_refreshTableView egoRefreshScrollViewDidEndDragging:myTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}




#pragma mark - 导航Menu按钮
-(void)initREMenuItem{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}
- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"使用说明"
                                                    subtitle:@"operation instruction"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"程序更新"
                                                       subtitle:@"Updata the Application"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             
        NSURL* url = [[ NSURL alloc ] initWithString :@"http://www.baidu.com"];
        [[UIApplication sharedApplication ] openURL: url];
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"手电筒"
                                                        subtitle:@"Open/Close the flashlight"
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              [self switchChanged];
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"退出"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    profileItem.tag = 3;
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}





#pragma mark - UITableView 计划列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SharedModel getInstance].planList.count;
//    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 1) {
        //改变CELL 的颜色 只能在这里面改
        cell.backgroundColor = [Colorful Clouds];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:247/255.0f green:250/255.0f blue:255/255.0f alpha:1.0];
    }
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [Colorful DarkGreen];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckCell *cell;
    cell = (CheckCell *)[tableView dequeueReusableCellWithIdentifier:@"CheckCell"];
    if (!cell) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"CheckCell" owner:self options:nil] lastObject];
    }
    PlanInfo *plan = [[SharedModel getInstance].planList objectAtIndex:indexPath.row];
    [cell initWithPlanInfo:plan];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckDetailViewController *detaiView = [[CheckDetailViewController alloc] initWithNibName:@"CheckDetailViewController" bundle:nil];
    detaiView.selectPlan = [[SharedModel getInstance].planList objectAtIndex:indexPath.row];
    
    detaiView.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaiView animated:YES];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 38)];
    
    headerLabel.text = [NSString stringWithFormat:@"未抽检:%d   ", [[SharedModel getInstance].planList count]];
    
    [headerLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [headerLabel setTextColor:[Colorful Wet]];
    [headerLabel setBackgroundColor:[Colorful Turquoise]];
    [headerLabel setAlpha:0.7];
    headerLabel.textAlignment = NSTextAlignmentRight;
    return headerLabel;
}



#pragma mark - 底部弹出的上传进度View
-(void)initBottomPushView{
    [pushView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
    [self.view addSubview:pushView];
}

-(void)moveBottomPushView:(NSString *)type{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    CGRect rect = [pushView frame];

    if ([type isEqual: UP]) {
        rect.origin.y = SCREEN_HEIGHT - 100;
    }else {
        rect.origin.y = SCREEN_HEIGHT + 100;
    }

    [pushView setFrame:rect];
    [UIView commitAnimations];
}
-(void)refreshPushLabel{
    
    pushLabel.text = [NSString stringWithFormat:@"正在上传照片...剩余%d张", [SharedModel getInstance].photosList.count];
    if ([SharedModel getInstance].photosList.count < 1) {
        [self moveBottomPushView:DOWM];
        [_timer invalidate];
    }

}

#pragma mark - 开辟线程上传图片
//第一次启动时需要读一遍Plist文件
-(void)initPhotoPlist{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[SharedModel getInstance].plistPath]) {
        if([NSMutableArray arrayWithContentsOfFile:[SharedModel getInstance].plistPath]){
            [SharedModel getInstance].photosList = [NSMutableArray arrayWithContentsOfFile:[SharedModel getInstance].plistPath];
            NSLog(@"未传照片数：%d", [SharedModel getInstance].photosList.count);
        }
        
    }
}

-(void)openNSThread{
    //开启线程传照片
    
    [self moveBottomPushView:UP];
    [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];

}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(SendPhoto) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

//执行网络上传图片 以及删图片
-(void)SendPhoto{
    
    NSMutableDictionary *lastPhtoto = [[SharedModel getInstance].photosList lastObject];
    if([Utility sendPhotoWithDic:lastPhtoto]){
        
    //删除照片
    NSFileManager *filemanager = [NSFileManager defaultManager];
    [filemanager removeItemAtPath:[lastPhtoto objectForKey:@"imagefilePath"] error:nil];
    //删除图片相关信息
    [[SharedModel getInstance].photosList removeLastObject];
    [[SharedModel getInstance].photosList writeToFile:[SharedModel getInstance].plistPath atomically:YES];
    
    [self performSelectorOnMainThread:@selector(refreshPushLabel) withObject:nil waitUntilDone:YES];
    }
    
    
}


#pragma mark - menu菜单中的操作
//手电筒开关动作
- (void)switchChanged{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (setting) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                setting = NO;
                [SharedModel getInstance].mySwitch = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                setting = YES;
                [SharedModel getInstance].mySwitch = NO;
            }
            [device unlockForConfiguration];
        }
    }
    
}












@end
