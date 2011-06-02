//
//  MessageUploadController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

#import "KaistMapView.h"

#import "MBProgressHUD.h"
@interface MessageUploadController : TTPostController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    KaistMapView *_mapView;
    
    UIButton *imageButton;
    UIButton *geoButton;
    BOOL haveImage;
    UIImage *selectedImage;
    
    UIImageView *checkGeo;
    UIImageView *checkImage;
    
    UIImagePickerController *imagePickerController;
    
    MBProgressHUD *HUD;
    
    NSMutableDictionary *additional;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSMutableDictionary *additional;
-(void *)showHUD:(NSString *)message type:(int)type;
-(void)postMale;
-(void)postFemale;
-(void)setting;
@end
