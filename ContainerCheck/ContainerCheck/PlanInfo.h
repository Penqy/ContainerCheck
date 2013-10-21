//
//  PlanInfo.h
//  ContainerCheck
//
//  Created by LD on 13-9-6.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanInfo : NSObject

@property NSString * plan_id;
@property NSString * plan_type;
@property NSString * para1;//箱号
@property NSString * qbid;//预约号
@property NSString * p_otime;//操作时间
@property NSString * stn_code;//站名略码
@property NSString * notes;//汽车队
@property NSString * m_position;//汽车号
@property NSArray  * plan_detail;
@property NSString * para7;//抽检通过标志
@property NSString * o_id;//集箱ID

-(id)initWithObject:(id)object;
@end
