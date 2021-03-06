//
//  MessageUploadController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageUploadController.h"


#import "UserInfoContainer.h"


#import "ASIFormDataRequest.h"

#import "NSDictionary_JSONExtensions.h"

@implementation MessageUploadController

@synthesize imagePickerController,additional;
- (void)didReceiveMemoryWarning
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"메시지 입력";
        self.textView.font=[UIFont boldSystemFontOfSize:16.0f];
        
        [self setting];
    }
    return self;
}
- (id) initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    self = [super init];
    if (self != nil) {
        self.title=@"메시지 입력";
        self.textView.font=[UIFont boldSystemFontOfSize:16.0f];
        
        [self setting];
        
        self.additional = [query objectForKey:@"additional"];
        NSLog(@"additional %@",self.additional);
        
    }
    return self;
}
-(void)setting{
    NSLog(@"SEtting");
    geoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    geoButton.frame=CGRectMake(270, 195, 40, 40);
    geoButton.contentMode=UIViewContentModeScaleAspectFit;
    [geoButton setImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
    [geoButton addTarget:self action:@selector(geoClicked) forControlEvents:UIControlEventTouchUpInside];
    checkGeo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-check.png"]];
    checkGeo.frame=CGRectMake(22, 24, 12, 12);
    checkGeo.hidden=YES;
    [geoButton addSubview:checkGeo];
    [self.view addSubview:geoButton];
    
    imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame=CGRectMake(235, 195, 40, 40);
    imageButton.contentMode=UIViewContentModeScaleAspectFit;
    imageButton.clipsToBounds=YES;
    imageButton.imageView.clipsToBounds=YES;
    [imageButton setImage:[UIImage imageNamed:@"upload-photo.png"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(imgClicked) forControlEvents:UIControlEventTouchUpInside];
    
    checkImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-check.png"]];
    checkImage.frame=CGRectMake(24, 24, 12, 12);
    [imageButton addSubview:checkImage];
    checkImage.hidden=YES;
    [self.view addSubview:imageButton];
    
    if(![[UserInfoContainer sharedInfo] isMale]){
        NSLog(@"female");
        imageButton.hidden=YES;
        geoButton.hidden=NO;
        
    }else{
        NSLog(@"male");
        imageButton.hidden=NO;
        geoButton.hidden=YES;
        imageButton.frame=geoButton.frame;
        [self.view bringSubviewToFront:imageButton];
        //imageButton.frame= geoButton.frame;
    }
}

-(void)viewDidLoad{
    //[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"123123: %@",[UserInfoContainer sharedInfo].gender);
    if(![[UserInfoContainer sharedInfo] isMale]){
        NSLog(@"female");
        imageButton.hidden=YES;
        geoButton.hidden=NO;
        
    }else{
        NSLog(@"male");
        imageButton.hidden=NO;
        geoButton.hidden=YES;
        //imageButton.frame= geoButton.frame;
    }
}

-(void)geoClicked{
    checkGeo.hidden=NO;
    [self.textView resignFirstResponder];
    if(_mapView == nil){
        _mapView = [[KaistMapView alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height-216, 310, 206)];
        [self.view addSubview:_mapView];
    }

}

-(void)post{
    NSLog(@"Post Clicked : USER : %@",[[UserInfoContainer sharedInfo] phone]);
    NSLog(@"%@",self.textView.text);
    NSLog(@"%f %f",_mapView.coordinate.latitude, _mapView.coordinate.longitude);
    
    if([[UserInfoContainer sharedInfo] isMale]){
        [self postMale];
    }else{
        [self postFemale];
    }
    /*
     NSData* imageData;
     if(selectedImage != nil)
        imageData=UIImagePNGRepresentation(selectedImage);
    */
}
-(void)postMale{
    NSLog(@"Post Male");
    /*QUERY_ANSWER_URL*/
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:QUERY_ANSWER_URL]];
    [request addPostValue:[[UserInfoContainer sharedInfo] phone] forKey:@"user"];
    [request addPostValue:[additional objectForKey:@"phone"] forKey:@"target_user"];
    
    if(selectedImage != nil){
        NSData* imageData=UIImagePNGRepresentation(selectedImage);
        [request addFile:imageData withFileName:[NSString stringWithFormat:@"%@.png",[[UserInfoContainer sharedInfo] phone]] andContentType:@"image/jpeg" forKey:@"photo"];
    }
    
    [request addPostValue:[additional objectForKey:@"query_id"] forKey:@"query_id"];
    [request addPostValue:self.textView.text forKey:@"message"];
    [self showHUD:@"Registering ..." type:TYPE_LOADING];
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
                BOOL animated = YES;
                
                [self.parentViewController viewWillAppear:animated];
                [self dismissPopupViewControllerAnimated:animated];
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
-(void)postFemale{
    NSLog(@"Post Female");
    //[[UserInfoContainer sharedInfo] phone]
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:QUERY_REGISTER_URL]];
    [request addPostValue:[[UserInfoContainer sharedInfo] phone] forKey:@"phone"];
    [request addPostValue:self.textView.text forKey:@"message"];
    [request addPostValue:[NSString stringWithFormat:@"%f",_mapView.coordinate.latitude] forKey:@"lat"];
    [request addPostValue:[NSString stringWithFormat:@"%f",_mapView.coordinate.longitude] forKey:@"lng"];
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
                //TODO: Succes -> Set to UserInfoContainer & go to tabbar
                BOOL animated = YES;
                
                [self.parentViewController viewWillAppear:animated];
                [self dismissPopupViewControllerAnimated:animated];
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

-(void)imgClicked{
    NSString *destructive=nil;
    if(haveImage){
        destructive=@"삭제하기";
    }
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:destructive otherButtonTitles:@"사진 찍기",@"보관함에서 선택하기", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	[popupQuery release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0 && !haveImage || buttonIndex == 1 && haveImage) {
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.delegate = self;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.allowsEditing=YES;
            [self presentModalViewController:self.imagePickerController animated:YES];
		}
	} else if (buttonIndex == 1 && !haveImage || buttonIndex == 2 && haveImage) {
		[actionSheet resignFirstResponder];
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.allowsEditing=YES;
        [self presentModalViewController:self.imagePickerController animated:YES];
	} else if (buttonIndex == 0 && haveImage) {
		//[imageButton setImage:[UIImage imageNamed:@"upload-photo.png"] forState:UIControlStateNormal];
        haveImage=NO;
        selectedImage=nil;
        checkImage.hidden=YES;
	} else{
        //NSLog(@"Cancel");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    selectedImage=[[UIImage alloc] initWithData:UIImagePNGRepresentation(img)];
    //[imageButton setImage:img forState:UIControlStateNormal];
    haveImage=YES;
    checkImage.hidden=NO;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];

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
@end
