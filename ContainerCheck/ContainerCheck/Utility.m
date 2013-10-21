//
//  Utility.m
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import "Utility.h"
#import "PlanInfo.h"


@implementation Utility

+ (NSDictionary *)getRequestDicForParam:(NSString *)_paramStr SendCode:(NSString *)code{
    NSDictionary *resDict;
    //NSString *strURL = [NSString stringWithFormat:@"http://%@:9090/TPMS/GeneralServlet", IP];
    NSString *strURL = @"http://10.192.111.70:9090/TPMS/MapServlet";
    NSURL *url = [NSURL URLWithString:strURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:code forKey:@"code"];
    [request setPostValue:_paramStr forKey:@"params"];
    [request setPostValue:@"VHW@map_jxdc" forKey:@"map_type"];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        
        NSData *data  = [request responseData];
        resDict = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:nil];
        NSLog(@"res - %@", resDict);
    }else{
        resDict = nil;
    }
    
    return resDict;
}

+ (NSString *)timeStampAsString
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *  locationTime = [dateformatter stringFromDate:senddate];
    return locationTime;
}



+(BOOL)getCheckPlan{
    BOOL flag = NO;
       
    NSDictionary *resDict = [self getRequestDicForParam:@"JX" SendCode:@"1169"];
    if (resDict != nil) {
        //清除planList
        [[SharedModel getInstance].planList removeAllObjects];
        
        if (![resDict isKindOfClass:[NSNull class]]) {//防止取到0条数据报错
            NSEnumerator *enumer = [resDict objectEnumerator];
            id object;
            while(object = [enumer nextObject])
            {
                PlanInfo *newPlan = [[PlanInfo alloc] initWithObject:object];
                [[SharedModel getInstance].planList addObject:newPlan];
                
            }
        }
      
        flag = YES;
    }
    
    return flag;
}

+(BOOL)sendPlanid:(NSString *)plan_id ParaFlag:(NSString *) _param7{
    BOOL flag = NO;
    //设参数
    NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
    [_paramDic setValue:plan_id forKey:@"plan_id"];
    [_paramDic setValue:_param7 forKey:@"check_result"];
    [_paramDic setValue:@"1172" forKey:@"code"];
    //转成json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_paramDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //调用方法获取返回值
    NSDictionary *resDict = [self getRequestDicForParam:jsonStr SendCode:@"1172"];
    NSString *mesg = [resDict objectForKey:@"message"];
    if ([mesg isEqualToString:@"true"]) {
        flag = YES;
    }
    
    return flag;
}

//延续用老的接口*******生成filename字符串：ID(箱ID)@类型@照片状态@照片名字@操作人@时间@DIC号@汽车号@股道码@顺位@车次(箱号)*********/
+(BOOL)sendPhotoWithDic:(NSMutableDictionary *)_photoDic{
    BOOL flag = NO;
    NSString *planid = [_photoDic objectForKey:@"pic_id"];
    NSString *choseType = [_photoDic objectForKey:@"pic_seq"];
    NSString *imageType = [_photoDic objectForKey:@"pic_type"];
    NSString *carnum = [_photoDic objectForKey:@"car_num"];
    NSString *gdm = @"";
    NSString *carseq = @"";
    NSString *carcalss = [_photoDic objectForKey:@"train_number"];
    NSString *userName = [_photoDic objectForKey:@"operators"];
    NSString *imagename = [_photoDic objectForKey:@"pic_name"];
    NSString *dicName = @"YES";
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@@%@@%@@%@@%@ @%@@%@@%@@%@@%@@%@",
                          planid,
                          choseType,
                          imageType,
                          imagename,
                          userName,
                          [self timeStampAsString],
                          dicName,
                          carnum,
                          gdm,
                          carseq,
                          carcalss, nil];
    NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:[_photoDic objectForKey:@"imagefilePath"]];
    
    // setting up the URL to post to
	NSString *urlString = [NSString  stringWithFormat:@"http://%@:9090/TPMS/ImageHandlerServlet_JX", IP];

	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];//设置一次请求X秒， 无反应就返回。
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
    //test解决中文乱码问题
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp);
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName ] dataUsingEncoding:enc]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

    NSLog(@"HTTPPost retrun : %@", returnString);
    if ([returnString isEqualToString:dicName]) {
        
        flag = YES;
    }
    
    return flag;
}

@end
