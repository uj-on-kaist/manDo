//
//  MainTabBarController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MainTabBarController.h"
#import "Three20UI/UITabBarControllerAdditions.h"


@interface UITabBarController (private)
- (UITabBar *)tabBar;
@end


@implementation MainTabBarController

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabURLs:[NSArray arrayWithObjects:@"tt://home",
                      @"tt://history",
                      @"tt://message",
                      @"tt://setting",
                      nil]];
    
    CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v setBackgroundColor:RGBCOLOR(48,44,41)];
    [v setAlpha:0.85];
    [[self tabBar] insertSubview:v atIndex:0];
    [v release];
    
    
    UIImageView *bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
    [self.view addSubview:bg];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [bg setAlpha:0];
    [UIView commitAnimations];
}

@end