//
//  SignInController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Three20/Three20.h"

#import "MBProgressHUD.h"

@interface SignInController : TTViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    UITableView *_tableView;
    
    UITextField *idField;
    UITextField *pwField;
    
    MBProgressHUD *HUD;
}
-(void *)showHUD:(NSString *)message type:(int)type;
@end
