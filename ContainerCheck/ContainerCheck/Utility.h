//
//  Utility.h
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface Utility : NSObject

+(BOOL)getCheckPlan;//获取抽检计划
+(BOOL)sendPlanid:(NSString *)plan_id ParaFlag:(NSString *)_param7;//抽检是否通过2(已抽检)/3(抽检未通过)
+(BOOL)sendPhotoWithDic:(NSMutableDictionary *)_photoDic;//上传照片


+ (NSDictionary *)getRequestDicForParam:(NSString *)_paramDic SendCode:(NSString *)code;//封装方法
+ (NSString *)timeStampAsString;//获取系统时间



@end
