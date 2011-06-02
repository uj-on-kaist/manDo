//
//  ManDoAppDelegate.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "ManDoAppDelegate.h"

#import "ManDoViewController.h"

#import "MainTabBarController.h"
#import "SignUpController.h"
#import "SignInController.h"
#import "Three20TestView.h"
#import "TestViewController.h"


#import "MessageViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"

#import "MessageUploadController.h"
#import "MessageDetailViewController.h"
#import "QueryDetailView.h"

#import "StyleSheet.h"
#import "Three20/Three20.h"

#import "UserInfoContainer.h"
@implementation ManDoAppDelegate


@synthesize window;

#pragma mark -
#pragma mark Application lifecycle
- (void)applicationDidFinishLaunching:(UIApplication*)application {
	[TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
    
	TTNavigator* navigator = [TTNavigator navigator];
	//navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
    [map from:@"tt://tabbar" toSharedViewController:[MainTabBarController class]];
    
    [map from:@"tt://signup" toViewController:[SignUpController class]];
    [map from:@"tt://signin" toModalViewController:[SignInController class]];
    
    [map from:@"tt://home" toViewController:[ManDoViewController class]];
    [map from:@"tt://history" toViewController:[HistoryViewController class]];
    [map from:@"tt://message" toViewController:[MessageViewController class]];
    [map from:@"tt://message/detail" toViewController:[MessageDetailViewController class]];

    [map from:@"tt://setting" toViewController:[SettingViewController class]];
    
    [map from:@"tt://query/detail" toViewController:[QueryDetailView class]];
    
    
    [map from:@"tt://upload/message" toViewController:[MessageUploadController class]];
    
    
    [map from:@"tt://test" toViewController:[Three20TestView class]];
    
	//if (![navigator restoreViewControllers]) {
    //[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://about"]];
    //[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://a"]];
    
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabbar"]];
    
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://signin"];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
    
    window.backgroundColor=[UIColor clearColor];
    
    
    //[[UserInfoContainer sharedInfo] getMyList];
    
    //NSLog(@"%@",[[UserInfoContainer sharedInfo] getGirlName:@"123"]);
	//}
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}

@end
