//
//  CheckCell.m
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import "CheckCell.h"

@implementation CheckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithPlanInfo:(PlanInfo *)plan{
    
    self.para1Label.text        = plan.para1;
    self.notesLabel.text        = plan.notes;
    self.m_positionLabel.text   = plan.m_position;
    self.qbidLabel.text         = [NSString stringWithFormat:@"预约号:%@", plan.qbid];
    
    
}

@end
