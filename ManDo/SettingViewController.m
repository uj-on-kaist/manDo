//
//  SettingViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SettingViewController.h"

#import "UserInfoContainer.h"


#import "ASIFormDataRequest.h"

#include "NSDictionary_JSONExtensions.h"

@implementation SettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UserInfoContainer *user=[UserInfoContainer sharedInfo];
        
        self.title=user.name;
        self.tabBarItem.title=user.name;
        self.tabBarItem.image=[UIImage imageNamed:@"house.png"];
        
        self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
        
        
        deptField=[[UITextField alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
        ageField=[[UITextField alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
        
        deptField.delegate=self;
        ageField.delegate=self;
        
        typeSegment=[[UISegmentedControl alloc] initWithItems:
                        [NSArray arrayWithObjects:@"도도한",@"섹시한", @"귀여운", nil]];
        typeSegment.frame=CGRectMake(100, 10, 200, 24);
        typeSegment.segmentedControlStyle=UISegmentedControlStyleBar;
        typeSegment.tintColor=(UIColor *)TTSTYLE(toolbarTintColor);
        ageField.keyboardType=UIKeyboardTypeNumberPad;
        
        deptField.autocorrectionType=UITextAutocorrectionTypeNo;
        deptField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        
        
        
        
        _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-39) style:UITableViewStyleGrouped] autorelease];
        _tableView.backgroundColor=(UIColor *)TTSTYLEVAR(tabTintColor);
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
        [self.view addSubview:_tableView];
        
        TTView *headerView=[[TTView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        headerView.backgroundColor=(UIColor *)TTSTYLE(profileHeaderView);
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-10, 320, 10)];
        view.backgroundColor=_tableView.backgroundColor;
        [headerView addSubview:view];
        [_tableView setTableHeaderView:headerView];
        
        
        
        
        profile=[[EGOImageView alloc] initWithImage:[UIImage imageNamed:@"female.png"]];
        if([user isMale]){
            profile.image=[UIImage imageNamed:@"male.png"];
        }else{
            profile.image=[UIImage imageNamed:@"female.png"];
        }
        
        profile.frame=CGRectMake(10, 10, 100, 100);
        profile.layer.cornerRadius=10.0f;
        profile.clipsToBounds=YES;
        [headerView addSubview:profile];
        
        TTTabBar *_tabBar2 = [[TTTabBar alloc] initWithFrame:CGRectMake(0, 120,320, 40)];
        _tabBar2.tabItems = [NSArray arrayWithObjects:
                             [[[TTTabItem alloc] initWithTitle:@"Edit Profile"] autorelease],
                             nil];
        _tabBar2.selectedTabIndex = 0;
        _tabBar2.delegate=self;
        [headerView addSubview:_tabBar2];
        
        
        //여자 ♀",@"남자 ♂
        gender=[[UILabel alloc] initWithFrame:CGRectMake(120, 20, 170, 24)];
        gender.text=user.name;
        gender.textColor=RGBCOLOR(70, 105, 100);
        gender.backgroundColor=[UIColor clearColor];
        gender.font=[UIFont boldSystemFontOfSize:18.0f];
        
        [headerView addSubview:gender];
        
        age=[[UILabel alloc] initWithFrame:CGRectMake(120, 44, 70, 20)];
        age.text=user.age;
        age.textColor=[UIColor lightGrayColor];
        age.backgroundColor=[UIColor clearColor];
        age.font=[UIFont boldSystemFontOfSize:14.0f];
        [headerView addSubview:age];
        
        dept=[[UILabel alloc] initWithFrame:CGRectMake(120, 64, 170, 20)];
        dept.text=user.majorIn;
        dept.textColor=[UIColor lightGrayColor];
        dept.backgroundColor=[UIColor clearColor];
        dept.font=[UIFont boldSystemFontOfSize:14.0f];
        [headerView addSubview:dept];
        
        phone=[[UILabel alloc] initWithFrame:CGRectMake(120, 84, 170, 20)];
        phone.text=user.phone;
        phone.textColor=[UIColor lightGrayColor];
        phone.font=[UIFont boldSystemFontOfSize:14.0f];
        phone.backgroundColor=[UIColor clearColor];
        [headerView addSubview:phone];
        
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(!_tableView.scrollEnabled){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        
        CGRect frame= _tableView.frame;
        frame.size.height-=(216-39);
        _tableView.frame=frame;        
        [UIView commitAnimations];
        
        _tableView.scrollEnabled=YES;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked)];
}

-(void)doneButtonClicked{
    [deptField resignFirstResponder];
    
    [ageField resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem=nil;
    if(_tableView.scrollEnabled){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        
        CGRect frame= _tableView.frame;
        frame.size.height+=(216-39);
        _tableView.frame=frame;
        _tableView.scrollEnabled=NO;
        
        [UIView commitAnimations];
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex 
{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"SettingView Appeared");
    
    
    [self updateUserInfo];
    //TODO: refresh in here
    //if(![user.imageURL isEqualToString:@""])
        //[profile setImageURL:[NSURL URLWithString:user.imageURL]];
}

-(void)getUserInfo{
    UserInfoContainer *user=[UserInfoContainer sharedInfo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_USER_URL,user.phone]]];
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
-(void)updateUserInfo{
    UserInfoContainer *user=[UserInfoContainer sharedInfo];
    NSLog(@"%@",user.name);
    self.title=user.name;
    self.tabBarItem.title=user.name;
    
    NSString *genderSymbol=@"♂";
    if([user isMale]){
        profile.image=[UIImage imageNamed:@"male.png"];
    }else{
        profile.image=[UIImage imageNamed:@"female.png"];
    }

    gender.text=[NSString stringWithFormat:@"%@ %@",user.name , genderSymbol];
    phone.text=[NSString stringWithFormat:@"전화번호 %@",user.phone];
    age.text=[NSString stringWithFormat:@"나이 %@세",user.age];
    dept.text=[NSString stringWithFormat:@"전공 %@",user.majorIn];
    if([user isMale]){
        profile.image=[UIImage imageNamed:@"male.png"];
    }
    
    deptField.text=user.majorIn;
    ageField.text=user.age;
    typeSegment.selectedSegmentIndex=[user.type intValue]-1;
}


-(void)logout{
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://signin"];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [self showHUD:@"Updating..." type:TYPE_LOADING];
        
        UserInfoContainer *user=[UserInfoContainer sharedInfo];

        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:MODIFY_URL]];
        NSLog(@"%@/%@/%@/%@",user.phone, deptField.text, ageField.text,[NSString stringWithFormat:@"%d",typeSegment.selectedSegmentIndex+1]);
        [request addPostValue:user.phone forKey:@"phone"];
        [request addPostValue:deptField.text forKey:@"major"];
        [request addPostValue:ageField.text forKey:@"age"];
        [request addPostValue:[NSString stringWithFormat:@"%d",typeSegment.selectedSegmentIndex+1] forKey:@"girls_type"];
        
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
                    [self showHUD:@"Success" type:TYPE_SUCCESS];
                    
                    //User Refresh
                    [self getUserInfo];
                    [self updateUserInfo];
                    
                    
                    [self doneButtonClicked];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) return 36;
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    if(!(cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier])){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if(indexPath.section == 0){
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        NSString *label=@"";
        switch (indexPath.row) {
            case 0:
                label=@"과";
                break;
            case 1:
                label=@"나이";
                break;
            case 2:
                label=@"타입";
                break;
            default:
                break;
        }
        
        cell.textLabel.text=label;
        cell.textLabel.textColor=RGBCOLOR(70, 105, 100);
        cell.textLabel.font=[UIFont boldSystemFontOfSize:14.0f];
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.textAlignment=UITextAlignmentLeft;
        switch (indexPath.row) {
            case 0:
                deptField.borderStyle=UITextBorderStyleNone;
                deptField.placeholder=@"과를 입력하세요";
                deptField.font=[UIFont boldSystemFontOfSize:14.0f];
                [cell addSubview:deptField];
                break;
            case 1:
                ageField.borderStyle=UITextBorderStyleNone;
                ageField.placeholder=@"나이를 입력하세요";
                ageField.font=[UIFont boldSystemFontOfSize:14.0f];
                [cell addSubview:ageField];
                break;
            case 2:
                typeSegment.selected=0;
                [cell addSubview:typeSegment];
                break;
            default:
                break;
        }
        
        
    }
    else if(indexPath.section == 1){
        cell.textLabel.text=@"Update";
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.backgroundColor=RGBCOLOR(70, 105, 100);
    }
    return cell;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doneButtonClicked];

    return YES;
}


-(void *)showHUD:(NSString *)message type:(int)type{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    if(type != TYPE_LOADING){
        NSString *filename=@"errorHUD.png";
        
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = message;
    }

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

@end
