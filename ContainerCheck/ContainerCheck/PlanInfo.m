//
//  PlanInfo.m
//  ContainerCheck
//
//  Created by LD on 13-9-6.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import "PlanInfo.h"

@implementation PlanInfo

@synthesize plan_id = _plan_id;
@synthesize plan_type = _plan_type;
@synthesize para1 = _para1;
@synthesize qbid = _qbid;
@synthesize p_otime = _p_otime;
@synthesize stn_code = _stn_code;
@synthesize notes = _notes;
@synthesize m_position = _m_position;
@synthesize plan_detail = _plan_detail;
@synthesize para7 = _para7;
@synthesize o_id = _o_id;


-(id)initWithObject:(id)object{
    
    self.plan_id        = [object objectForKey:@"plan_id"];
    self.plan_type      = [object objectForKey:@"plan_type"];
    self.qbid           = [object objectForKey:@"qbid"];
    self.p_otime        = [object objectForKey:@"p_otime"];
    self.stn_code       = [object objectForKey:@"stn_code"];
    self.notes          = [object objectForKey:@"notes"];
    self.m_position     = [object objectForKey:@"m_position"];
    self.plan_detail    = [object objectForKey:@"plan_detail"];
    self.para7          = [object objectForKey:@"para7"];
    if (self.plan_detail.count > 0) {
        
        self.para1      = [[self.plan_detail objectAtIndex:0] objectForKey:@"para1"];
        self.o_id       = [[self.plan_detail objectAtIndex:0] objectForKey:@"o_id"];
        
    }
    
    
    return self;
}

@end
