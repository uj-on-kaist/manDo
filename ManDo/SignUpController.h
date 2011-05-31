//
//  SigninController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 30..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Three20/Three20.h"
#import "ProfileView.h"


#import "HUDShowMaker.h"

@interface SignUpController : TTViewController <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,ProfileViewDelegate,UINavigationControllerDelegate> {
    UITableView *_tableView;
    
    UITextField *deptField;
    UITextField *ageField;
    UITextField *phoneField;
    
    UISegmentedControl *genderSegment;
    
    ProfileView *profileView;
    
    UIImagePickerController *imagePickerController;
    
    BOOL inProfileview;

    MBProgressHUD *HUD;
}

@end

