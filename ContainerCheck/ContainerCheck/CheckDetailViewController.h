//
//  CheckDetailViewController.h
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoStackView.h"
#import "PlanInfo.h"

@interface CheckDetailViewController : UIViewController<UIImagePickerControllerDelegate, PhotoStackViewDataSource, PhotoStackViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    PhotoStackView *myPhotoStark;
    
}


@property PlanInfo * selectPlan;

@property (strong, nonatomic) IBOutlet UILabel *m_positionLabel;
@property (strong, nonatomic) IBOutlet UILabel *para1Label;
@property (strong, nonatomic) IBOutlet UILabel *qbidLabel;
@property (strong, nonatomic) IBOutlet UILabel *p_otimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *PhotoCountLabel;


- (IBAction)PhotoAction:(id)sender;


@end
