//
//  SignInController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SignInController.h"

#import "UserInfoContainer.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

#include "NSDictionary_JSONExtensions.h"

@implementation SignInController



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
    
    phoneField=[[UITextField alloc] initWithFrame:CGRectMake(20, 13, 140, 20)];
    pwField=[[UITextField alloc] initWithFrame:CGRectMake(160, 13, 130, 20)];
    
    nameField=[[UITextField alloc] initWithFrame:CGRectMake(20, 13, 130, 20)];
    
    genderSelector=[[UISegmentedControl alloc] initWithItems:
                    [NSArray arrayWithObjects:@"남자",@"여자", nil]];
    genderSelector.frame=CGRectMake(180, 8, 120, 30);
    genderSelector.segmentedControlStyle=UISegmentedControlStyleBar;
    genderSelector.selectedSegmentIndex=0;
    
    phoneField.keyboardType=UIKeyboardTypeNumberPad;
    phoneField.returnKeyType=UIReturnKeyGo;
    pwField.keyboardType=UIKeyboardTypeAlphabet;
    pwField.returnKeyType=UIReturnKeyGo;
    
    nameField.returnKeyType=UIReturnKeyGo;
    nameField.delegate=self;
    phoneField.delegate=self;
    pwField.delegate=self;
        
    pwField.secureTextEntry=YES;
    pwField.autocorrectionType=UITextAutocorrectionTypeNo;
    pwField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
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
    
    
    [pwField becomeFirstResponder];
}
-(void)registerUser{
    NSString *phone=phoneField.text;
    NSString *name=nameField.text;
    NSString *gender=@"";
    
    if([genderSelector selectedSegmentIndex] == MAN_INDEX){
        gender=@"M";
    }else if([genderSelector selectedSegmentIndex] == WOMAN_INDEX){
        gender=@"F";
    }else{
        [self showHUD:@"No gender type" type:TYPE_ERROR];
        NSLog(@"Error no gender type");
        return;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REGISTER_URL]];
    [request addPostValue:phone forKey:@"phone"];
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:gender forKey:@"gender"];
    [self showHUD:@"Loading" type:TYPE_LOADING];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        [HUD hide:YES];
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                [self showHUD:[resultDict objectForKey:@"message"] type:TYPE_ERROR];
            }else{                
                //Succes -> Set to UserInfoContainer & go to tabbar
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_USER_URL,phone]]];
                [self showHUD:@"Sign in..." type:TYPE_LOADING];
                [request startSynchronous];
                NSError *error = [request error];
                if (!error) {
                    [HUD hide:YES];
                    NSString *response = [request responseString];
                    
                    NSError *jsonError = NULL;
                    NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
                    if(!jsonError){
                        NSLog(@"%@",resultDict);
                        if([[resultDict objectForKey:@"code"] intValue] == 1){
                            [self showHUD:[resultDict objectForKey:@"message"] type:TYPE_ERROR];
                        }else{                
                            //TODO: Succes -> Set to UserInfoContainer & go to tabbar
                            
                            UserInfoContainer *user=[UserInfoContainer sharedInfo];
                            
                            user.phone=[resultDict objectForKey:@"phone"];
                            user.gender=[resultDict objectForKey:@"gender"];
                            user.name=[resultDict objectForKey:@"name"];
                            user.age=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"age"]];
                            user.majorIn=[resultDict objectForKey:@"major"];
                            user.type=[resultDict objectForKey:@"girls_type"];
                            
                            
                            
                            [self dismissModalViewControllerAnimated:YES];
                            return;
                        }
                    }else{
                        NSLog(@"Original response: %@",response);
                        
                    }
                    
                }else{
                    [HUD hide:YES];
                    [self showHUD:[error localizedDescription] type:TYPE_ERROR];
                    NSLog(@"%@",[error localizedDescription]);
                }
            }
        }else{
            NSLog(@"Original response: %@",response);
        }
        
    }else{
        [HUD hide:YES];
        [self showHUD:[error localizedDescription] type:TYPE_ERROR];
        NSLog(@"%@",[error localizedDescription]);
    }
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *phone=phoneField.text;
    NSString *gender=@"";
    
    if([genderSelector selectedSegmentIndex] == MAN_INDEX){
        gender=@"M";
    }else if([genderSelector selectedSegmentIndex] == WOMAN_INDEX){
        gender=@"F";
    }else{
        [self showHUD:@"No gender type" type:TYPE_ERROR];
        NSLog(@"Error no gender type");
        return false;
    }
    
    
    //TODO: GET USER INFO & SET TO user
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_USER_URL,phone]]];
    [self showHUD:@"Sign in..." type:TYPE_LOADING];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        [HUD hide:YES];
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                [self showHUD:[resultDict objectForKey:@"message"] type:TYPE_ERROR];
            }else{                
                //TODO: Succes -> Set to UserInfoContainer & go to tabbar
                
                UserInfoContainer *user=[UserInfoContainer sharedInfo];
                
                user.phone=[resultDict objectForKey:@"phone"];
                user.gender=[resultDict objectForKey:@"gender"];
                user.name=[resultDict objectForKey:@"name"];
                user.age=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"age"]];
                user.majorIn=[resultDict objectForKey:@"major"];
                user.type=[resultDict objectForKey:@"girls_type"];
                
                [self dismissModalViewControllerAnimated:YES];
                
                return true;
            }
        }else{
            NSLog(@"Original response: %@",response);
            
        }
        
    }else{
        [HUD hide:YES];
        [self showHUD:[error localizedDescription] type:TYPE_ERROR];
        NSLog(@"%@",[error localizedDescription]);
    }
    
    /*
    UserInfoContainer *user=[UserInfoContainer sharedInfo];
    
    user.phone=phone;
    user.gender=gender;
    user.name=name;
    
    */
    
    /*
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://tabbar/refresh"];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
    */
    
    //[self dismissModalViewControllerAnimated:YES];
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
    
    if(type == TYPE_LOADING)
        [HUD showWhileExecuting:@selector(longTask) onTarget:self withObject:nil animated:YES];
    else
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    return HUD;
}
-(void)myTask {
    sleep(1);
}
-(void)longTask{
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        //HUD.progress = progress;
        usleep(50000);
    }
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
        inputField=phoneField;
        [cell addSubview:genderSelector];
        inputField.placeholder=@"전화번호";
        inputField.text=@"321";
    }else{
        inputField=pwField;
        inputField.placeholder=@"비밀번호";
        
        nameField.borderStyle=UITextBorderStyleNone;
        nameField.placeholder=@"이름";
        nameField.font=[UIFont boldSystemFontOfSize:16.0f];
        [cell addSubview:nameField];
    }
    inputField.borderStyle=UITextBorderStyleNone;
    
    inputField.font=[UIFont boldSystemFontOfSize:16.0f];
    
    [cell addSubview:inputField];
    
    return cell;
    
}

@end
