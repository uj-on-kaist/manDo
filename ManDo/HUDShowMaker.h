//
//  HUDShowMaker.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUDShowMaker : NSObject {
    
}

+(MBProgressHUD *)showHUD:(id)delegate forView:(id)view;

@end
