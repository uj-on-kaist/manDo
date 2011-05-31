//
//  Three20TestView.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "Three20TestView.h"

@implementation Three20TestView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"Test";
        self.tabBarItem.image=[UIImage imageNamed:@"tab.png"];
    }
    return self;
}

@end
