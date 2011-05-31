//
//  HistoryViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "HistoryViewController.h"


@implementation HistoryViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"History";
        self.tabBarItem.image=[UIImage imageNamed:@"history.png"];
    }
    return self;
}
@end
