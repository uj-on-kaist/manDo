//
//  UserInfoContainer.h
//  ManDo
//
//  Created by 정의준 on 11. 6. 1..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@class  USER_GIRL;
@interface UserInfoContainer : NSObject {
    NSString *phone;
    NSString *name;
    NSString *age;
    NSString *majorIn;
    NSString *type;
    NSString *gender;
    NSString *imageURL;
    
    
    sqlite3 *db;
    
    USER_GIRL *girls;
}

@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *age;
@property (nonatomic,retain) NSString *majorIn;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *gender;

@property (nonatomic,retain) NSString *imageURL;

+ (UserInfoContainer *)sharedInfo;
-(NSMutableArray *)getMyList;
-(BOOL)isMale;



-(void)addGirl:(NSString *)phoneNumber;

-(NSString *)getGirlName:(NSString *)phoneNumber;
-(void)check_insert:(NSString *)phoneNumber;


-(NSString *)getUserPicture:(NSString *)phoneNumber;
@end
