//
//  MessageUploadController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageUploadController.h"


@implementation MessageUploadController

@synthesize imagePickerController;
- (void)didReceiveMemoryWarning
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"메시지 입력";
        self.textView.font=[UIFont boldSystemFontOfSize:16.0f];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(270, 195, 40, 40);
        btn.contentMode=UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(geoClicked) forControlEvents:UIControlEventTouchUpInside];
        checkGeo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-check.png"]];
        checkGeo.frame=CGRectMake(22, 24, 12, 12);
        checkGeo.hidden=YES;
        [btn addSubview:checkGeo];
        [self.view addSubview:btn];
        
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
    }
    return self;
}


-(void)viewDidLoad{
    //[super viewDidLoad];
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
    NSLog(@"Post Clicked");
    NSLog(@"%@",self.textView.text);
    NSLog(@"%f %f",_mapView.coordinate.latitude, _mapView.coordinate.longitude);
    /*
     NSData* imageData;
     if(selectedImage != nil)
        imageData=UIImagePNGRepresentation(selectedImage);
    */
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
    selectedImage=img;
    //[imageButton setImage:img forState:UIControlStateNormal];
    haveImage=YES;
    checkImage.hidden=NO;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];

}

@end
