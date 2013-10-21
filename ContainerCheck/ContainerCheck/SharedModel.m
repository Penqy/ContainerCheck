//
//  SharedModel.m
//  ContainerCheck
//
//  Created by LD on 13-8-28.
//  Copyright (c) 2013年 LD. All rights reserved.
//

#import "SharedModel.h"
#import "PlanInfo.h"

@implementation SharedModel

static SharedModel * sharedModel = nil;
@synthesize photosList;
@synthesize plistPath;
@synthesize planList;
//@synthesize selectPlan;



+ (SharedModel*) getInstance{
    @synchronized(self){
        if (sharedModel == nil)
        {
            sharedModel = [[super alloc]init];
        }
    }
    return sharedModel;
    
}

+ (id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedModel == nil) {
            sharedModel = [super allocWithZone:zone];
            return  sharedModel;
        }
    }
    return nil;
}

- (id) init{
    //alloc
    photosList = [[NSMutableArray alloc] init];
    planList = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    plistPath = [docDir stringByAppendingPathComponent:@"photolist.plist"];
    self.mySwitch = NO;
    
    return self;
}


@end
