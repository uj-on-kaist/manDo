//
//  UserInfoContainer.h
//  ManDo
//
//  Created by 정의준 on 11. 6. 1..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfoContainer : NSObject {
    NSString *phone;
    NSString *name;
    NSString *age;
    NSString *majorIn;
    NSString *type;
    NSString *gender;
    NSString *imageURL;
}

@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *age;
@property (nonatomic,retain) NSString *majorIn;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *gender;

@property (nonatomic,retain) NSString *imageURL;
/*
 
 
 
 
 */

+ (UserInfoContainer *)sharedInfo;

-(BOOL)isMale;

@end
