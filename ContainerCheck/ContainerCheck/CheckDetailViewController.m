//
//  CheckDetailViewController.m
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import "CheckDetailViewController.h"
#import "Utility.h"
#import <AVFoundation/AVFoundation.h>


@interface CheckDetailViewController (){
   NSMutableArray *_photos;
}

@end

@implementation CheckDetailViewController
@synthesize selectPlan;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详细";
        _photos = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initPhotoStark];
    [self initUILabel];
}

- (void)viewDidDisappear:(BOOL)animated{
    //_photos = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)PhotoAction:(id)sender {
    //Take Photo with Camera
    @try {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
            [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
            [cameraVC setDelegate:self];
            [cameraVC setAllowsEditing:NO];
            //显示Camera VC
            [self presentViewController:cameraVC animated:YES completion:^{}];
            
        }else {
            NSLog(@"Camera is not available.");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Camera is not available.");
    }

}

#pragma mark - UILabel初始化
-(void)initUILabel{
    
    self.m_positionLabel.text   = [NSString stringWithFormat:@"车号:%@", selectPlan.m_position];
    self.para1Label.text        = [NSString stringWithFormat:@"箱号:%@", selectPlan.para1];
    self.qbidLabel.text         = [NSString stringWithFormat:@"预约号:%@", selectPlan.qbid];
    self.p_otimeLabel.text      = [NSString stringWithFormat:@"预约时间:%@", selectPlan.p_otime];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionSheetPush)];
}


#pragma mark - 拍照以及保存
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 开线程保存图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [NSThread detachNewThreadSelector: @selector(_saveImage:) toTarget:self withObject:image];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    
}

-(void)_saveImage:(UIImage *)image{
    
    //调转图片角度
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0000000001);
    NSLog(@"image Data = %d", imageData.length);
    [_photos addObject:[UIImage imageWithData:imageData]];
    [self writeWithPhotoData:imageData];
    
    if (_photos.count < 7) {
        [myPhotoStark reloadData];
        [myPhotoStark goToPhotoAtIndex:_photos.count - 1];
    }
    
    myPhotoStark.userInteractionEnabled = _photos.count>0?YES:NO;
    //检测是否打开手电
    [self openFlashlight];
    //更新UI
    self.PhotoCountLabel.text = [NSString stringWithFormat:@"照片数:%d", _photos.count];
}
-(void)writeWithPhotoData:(NSData *)imageData{
    //生成名字、写入文件、文件路径写入全局的dic、dic再写成文件
    NSString *imagename = [[NSString alloc] initWithFormat:@"%@_%@.jpg", selectPlan.o_id, [self makeTimeName]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    /***********image 写入文件**************/
    NSString *imagefilePath = [docDir stringByAppendingPathComponent:imagename];
    [imageData writeToFile:imagefilePath atomically:YES];
    //文件路径及其他信息写入dic
    NSMutableDictionary *newPhotoList = [[NSMutableDictionary alloc] init];
    [newPhotoList setObject:imagename forKey:@"pic_name"];
    [newPhotoList setObject:imagefilePath forKey:@"imagefilePath"];
    //[newPhotoList setObject:selectPlan.o_id forKey:@"pic_id"];
    [newPhotoList setObject:[NSString stringWithFormat:@"%d", _photos.count] forKey:@"pic_seq"];
    [newPhotoList setObject:@"集箱抽检" forKey:@"pic_type"];
    [newPhotoList setObject:@"集箱外勤" forKey:@"operators"];
    [newPhotoList setObject:[Utility timeStampAsString] forKey:@"oper_date"];
    //[newPhotoList setObject:selectPlan.m_position forKey:@"car_num"];
    //[newPhotoList setObject:selectPlan.para1 forKey:@"train_number"];
    
    //dic写入全局的Dic 在写成文件
    [[SharedModel getInstance].photosList addObject:newPhotoList];
    [[SharedModel getInstance].photosList writeToFile:[SharedModel getInstance].plistPath atomically:YES];
}


-(NSString *)makeTimeName
{
    //文件以时间结尾只取时分秒
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HHmmss"];
    NSString *  locationTime = [dateformatter stringFromDate:senddate];
    return locationTime;
}

#pragma mark - PhotoStark 照片栈
-(void)initPhotoStark{

    if (!myPhotoStark) {
        myPhotoStark = [[PhotoStackView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//        myPhotoStark.backgroundColor = [UIColor blackColor];
        myPhotoStark.center = CGPointMake(self.view.center.x, 300);
        myPhotoStark.dataSource = self;
        myPhotoStark.delegate = self;
        myPhotoStark.userInteractionEnabled = _photos.count>0?YES:NO;
    }
    
    [self.view addSubview:myPhotoStark];
    
}


#pragma mark -
#pragma mark Deck DataSource Protocol Methods

-(NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack {
    return [_photos count];
}

-(UIImage *)photoStackView:(PhotoStackView *)photoStack photoForIndex:(NSUInteger)index {
    return [_photos objectAtIndex:index];
}

- (CGSize)photoStackView:(PhotoStackView *)photoStack photoSizeForIndex:(NSUInteger)index{
    CGSize size;
    UIImage *img    = [_photos objectAtIndex:index];
    size.height     = img.size.height>img.size.width?250:188;
    size.width      = img.size.height>img.size.width?188:250;
    return size;
}

#pragma mark -
#pragma mark Deck Delegate Protocol Methods

-(void)photoStackView:(PhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index {
    // User started moving a photo
}

-(void)photoStackView:(PhotoStackView *)photoStackView willFlickAwayPhotoAtIndex:(NSUInteger)index {
    // User flicked the photo away, revealing the next one in the stack
}

-(void)photoStackView:(PhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index {
//    self.pageControl.currentPage = index;
}

-(void)photoStackView:(PhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index {
    NSLog(@"selected %d", index);
}

#pragma  mark - 打开手电筒
-(void)openFlashlight{
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            BOOL setting = [SharedModel getInstance].mySwitch;
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch] && [device hasFlash]){
                
                [device lockForConfiguration:nil];
                if (setting) {
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device setFlashMode:AVCaptureFlashModeOn];
                } else {
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device setFlashMode:AVCaptureFlashModeOff];
                }
                [device unlockForConfiguration];
            }
        }

}


#pragma mark - 判定抽检是否通过
-(void)actionSheetPush{
    UIActionSheet *myaction = [[UIActionSheet alloc] initWithTitle:@"是否抽检通过"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:@"通过"
                                                 otherButtonTitles:@"不通过", nil];
    [myaction showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //通过
        if ([Utility sendPlanid:selectPlan.plan_id ParaFlag:@"2"]) {
            [SVProgressHUD showSuccessWithStatus:@"抽检成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络故障,请重试!"];
        }
        
    }else if(buttonIndex == 1){
        //不通过
        UIAlertView * myalter = [[UIAlertView alloc] initWithTitle:@"抽检"
                                                           message:@"确认此预约抽检不通过？"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:@"取消", nil];
        [myalter show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        //确认抽检不通过
        if ([Utility sendPlanid:selectPlan.plan_id ParaFlag:@"3"]) {
            [SVProgressHUD showSuccessWithStatus:@"抽检不通过"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络故障,请重试!"];
        }
    }
}





@end
