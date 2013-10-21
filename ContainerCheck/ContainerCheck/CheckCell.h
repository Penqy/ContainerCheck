//
//  CheckCell.h
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanInfo.h"

@interface CheckCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *para1Label;

@property (strong, nonatomic) IBOutlet UILabel *m_positionLabel;
@property (strong, nonatomic) IBOutlet UILabel *qbidLabel;

@property (strong, nonatomic) IBOutlet UILabel *notesLabel;



-(void)initWithPlanInfo:(PlanInfo *)plan;
@end
