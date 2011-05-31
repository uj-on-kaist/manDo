//
//  SigninController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 30..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SignUpController.h"

/*
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
    UIColor *color = RGBCOLOR(70, 105, 100);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    CGContextFillRect(context, rect);
    self.tintColor=RGBCOLOR(167, 196, 187);
}
@end
*/

@implementation SignUpController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)textFieldDidChange:(id)event{
    
}

- (void)didReceiveMemoryWarning
{
}
-(void)viewDidLoad{
    //[super loadView];
    UILabel *logoLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 240, 30)];
    logoLabel.text=@"manDo :-)";
    logoLabel.font=[UIFont boldSystemFontOfSize:20];
    logoLabel.textColor=[UIColor whiteColor];
    logoLabel.backgroundColor=[UIColor clearColor];
    self.navigationItem.titleView=logoLabel;
    
    self.view.backgroundColor=(UIColor *)TTSTYLE(backgroundColor);
    
    deptField=[[UITextField alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
    ageField=[[UITextField alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
    phoneField=[[UITextField alloc] initWithFrame:CGRectMake(100, 13, 200, 20)];
    
    ageField.keyboardType=UIKeyboardTypeNumberPad;
    phoneField.keyboardType=UIKeyboardTypeNumberPad;
    
    deptField.autocorrectionType=UITextAutocorrectionTypeNo;
    deptField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
    [deptField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -5, self.view.frame.size.width, 200) 
                                              style:UITableViewStyleGrouped];
        _tableView.scrollEnabled=NO;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    [self.view addSubview:_tableView];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"다음" style:UIBarButtonItemStyleBordered target:self action:@selector(next)];
    
    [deptField becomeFirstResponder];
    
    if(profileView == nil){
        profileView=[[ProfileView alloc] initWithFrame:CGRectMake(0, -5, self.view.frame.size.width, self.view.frame.size.height+5)];
        profileView.delegate=self;
    }
    
    if(inProfileview && imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera){
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"이전" style:UIBarButtonItemStyleBordered target:self action:nil];;
        
        deptField.userInteractionEnabled=NO;
        ageField.userInteractionEnabled=NO;
        phoneField.userInteractionEnabled=NO;
        
        
        [profileView.info setValue:[NSString stringWithFormat:@"%d",genderSegment.selectedSegmentIndex] forKey:@"gender"];
        [profileView.info setValue:deptField.text forKey:@"dept"];
        [profileView.info setValue:deptField.text forKey:@"age"];
        [profileView.info setValue:deptField.text forKey:@"phone"];
        
        //[profileView prepareView];
        [self.view addSubview:profileView];
    }
}

-(void)next{
    if(inProfileview){ return; }
    inProfileview=YES;
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"이전" style:UIBarButtonItemStyleBordered target:self action:nil];;
    
    deptField.userInteractionEnabled=NO;
    ageField.userInteractionEnabled=NO;
    phoneField.userInteractionEnabled=NO;
    
    
    [profileView.info setValue:[NSString stringWithFormat:@"%d",genderSegment.selectedSegmentIndex] forKey:@"gender"];
    [profileView.info setValue:deptField.text forKey:@"dept"];
    [profileView.info setValue:deptField.text forKey:@"age"];
    [profileView.info setValue:deptField.text forKey:@"phone"];
    
    //[profileView prepareView];
    [self.view addSubview:profileView];
    
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.view.layer addAnimation:animation forKey:@"SwitchToView1"];
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Academics";
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0){
        NSString *label=@"";
        switch (indexPath.row) {
            case 0:
                label=@"성별";
                break;
            case 1:
                label=@"과";
                break;
            case 2:
                label=@"나이";
                break;
            case 3:
                label=@"전화번호";
                break;
            default:
                break;
        }

        cell.textLabel.text=label;
        cell.textLabel.textColor=RGBCOLOR(70, 105, 100);
        cell.textLabel.font=[UIFont boldSystemFontOfSize:14.0f];
        
        if(indexPath.row > 0){
            UITextField *inputField;
            NSString *placeholder=@"";
            switch (indexPath.row - 1) {
                case 0:
                    inputField=deptField;
                    placeholder=@"전산학과";
                    break;
                case 1:
                    inputField=ageField;
                    placeholder=@"24";
                    break;
                case 2:
                    inputField=phoneField;
                    placeholder=@"010-1234-5678";
                    break;
                default:
                    break;
            }
            if(inputField != nil){
                inputField.borderStyle=UITextBorderStyleNone;
                inputField.placeholder=placeholder;
                inputField.font=[UIFont boldSystemFontOfSize:14.0f];
                [cell addSubview:inputField];
            }
        }
        else{
            genderSegment=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"여자 ♀",@"남자 ♂", nil]];
            genderSegment.segmentedControlStyle=UISegmentedControlStyleBar;
            //genderSegment.tintColor=RGBCOLOR(167, 196, 187);
            
            genderSegment.frame=CGRectMake(100, 12, 120, 24);
            
            [cell addSubview:genderSegment];
            
        }
    }
    
    return cell;
    
}


-(void)clickProfileButton{
    /*
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing=YES;
    [self presentModalViewController:imagePickerController animated:YES];
    */
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기",@"보관함에서 선택하기", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	[popupQuery release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
             imagePickerController = [[UIImagePickerController alloc] init];
             imagePickerController.delegate = self;
             imagePickerController.sourceType = 
             UIImagePickerControllerSourceTypeCamera;
             imagePickerController.allowsEditing=YES;
             [self presentModalViewController:imagePickerController animated:YES];
		}
	} else if (buttonIndex == 1) {
		[actionSheet resignFirstResponder];
         imagePickerController = [[UIImagePickerController alloc] init];
         imagePickerController.delegate = self;
         imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         imagePickerController.allowsEditing=YES;
         [self presentModalViewController:imagePickerController animated:YES];
	} else if (buttonIndex == 2) {
		//NSLog(@"3Destructive Button Clicked");
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	[profileView.profile setImage:img];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];
	
}




-(void)clickRegisterButton:(NSMutableDictionary *)info{
    
    HUD=[HUDShowMaker showHUD:self forView:self.view];
    [self.navigationController.view addSubview:HUD];
    
}

@end
