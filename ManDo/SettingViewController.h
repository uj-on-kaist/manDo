//
//  SettingViewController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

#import "EGOImageView.h"

#import "MBProgressHUD.h"

@interface SettingViewController : TTViewController <UITableViewDelegate, UITableViewDataSource, TTTabDelegate, UITextFieldDelegate>{
    UITableView *_tableView;
    //UITableView *_infoView;
    
    EGOImageView *profile;
    UILabel *gender;
    UILabel *age;
    UILabel *dept;
    UILabel *phone;
    
    UIToolbar *mKeyboardToolbar;
    UITextField *deptField;
    UITextField *ageField;
    UISegmentedControl *typeSegment;
    
    MBProgressHUD *HUD;
    
    
}


-(void *)showHUD:(NSString *)message type:(int)type;

-(void)doneButtonClicked;
-(void)getUserInfo;
-(void)updateUserInfo;
@end
