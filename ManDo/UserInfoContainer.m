//
//  UserInfoContainer.m
//  ManDo
//
//  Created by 정의준 on 11. 6. 1..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserInfoContainer.h"


@implementation UserInfoContainer

@synthesize phone,name,age,gender,type,majorIn;

@synthesize imageURL;

static UserInfoContainer *sharedInfo = NULL;

+ (UserInfoContainer *)sharedInfo{
    @synchronized(self) {
        if (sharedInfo == NULL)
            sharedInfo = [[self alloc] init];
    }   
    return(sharedInfo);
}


-(BOOL)isMale{

    if([gender isEqualToString:@"M"]){
        return YES;
    }
    return NO;
}

@end
