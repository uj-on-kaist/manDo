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
@interface MessageUploadController : TTPostController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    KaistMapView *_mapView;
    
    UIButton *imageButton;
    BOOL haveImage;
    UIImage *selectedImage;
    
    UIImageView *checkGeo;
    UIImageView *checkImage;
    
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;


@end