//
//  SharedModel.h
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//
//#import "PlanInfo.h"
#import <Foundation/Foundation.h>


@interface SharedModel : NSObject
@property (strong,nonatomic) NSMutableArray *photosList;//图片信息列表
@property (strong,nonatomic) NSString *plistPath;//Plist路径
@property BOOL mySwitch;//手电开关
@property (strong, nonatomic) NSMutableArray *planList;
//@property (strong, nonatomic) PlanInfo *selectPlan;//当前选择的Plan


+ (SharedModel *) getInstance;


@end
