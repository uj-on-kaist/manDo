//
//  ManDoAppDelegate.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManDoViewController;

@interface ManDoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ManDoViewController *viewController;

@end
