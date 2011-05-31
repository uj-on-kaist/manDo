//
//  SignInController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SignInController.h"


@implementation SignInController

#define TYPE_LOADING 0
#define TYPE_SUCCESS 1
#define TYPE_ERROR 2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor=RGBCOLOR(70, 105, 100);
    
    UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin-logo.png"]];
    logo.frame=CGRectMake(0, 30, 320, 60);
    [self.view addSubview:logo];
    
    idField=[[UITextField alloc] initWithFrame:CGRectMake(20, 13, 280, 20)];
    pwField=[[UITextField alloc] initWithFrame:CGRectMake(20, 13, 280, 20)];
    
    idField.keyboardType=UIKeyboardTypeAlphabet;
    idField.returnKeyType=UIReturnKeyGo;
    pwField.keyboardType=UIKeyboardTypeAlphabet;
    pwField.returnKeyType=UIReturnKeyGo;
    
    
    idField.delegate=self;
    pwField.delegate=self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 100) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"이 아이디로 가입하기" forState:UIControlStateNormal];
    btn.frame=CGRectMake(90, 210, 120, 30);
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self.view addSubview:btn];
    
    
    [idField becomeFirstResponder];
}
-(void)registerUser{
    [self showHUD:@"Loading" type:TYPE_LOADING];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[self showHUD:@"Error" type:TYPE_ERROR];
    
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://tabbar"];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
    
    return false;
}
-(void *)showHUD:(NSString *)message type:(int)type{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    if(type != TYPE_LOADING){
        NSString *filename=@"errorHUD.png";
    
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = message;
    }
    CGRect frame=HUD.frame;
    frame.origin.y-=55;
	HUD.frame=frame;
    //HUD.labelText = @"Loading";
    
    [self.navigationController.view addSubview:HUD];
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    return HUD;
}
-(void)myTask {
    sleep(3);
}
#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     TTURLAction *action = [TTURLAction actionWithURLPath:[links objectAtIndex:indexPath.row]];
     [action setAnimated:YES];
     [[TTNavigator navigator] openURLAction:action];*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    if(!(cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier])){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UITextField *inputField;
    if(indexPath.row == 0){
        inputField=idField;
        inputField.placeholder=@"아이디";
    }else{
        inputField=pwField;
        inputField.placeholder=@"비밀번호";
    }
    inputField.borderStyle=UITextBorderStyleNone;
    
    inputField.font=[UIFont boldSystemFontOfSize:16.0f];
    
    [cell addSubview:inputField];
    
    return cell;
    
}

@end
