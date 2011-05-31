//
//  ManDoAppDelegate.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ManDoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
