//
//  MessageViewController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface MessageViewController : TTViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    
    NSMutableArray *array;
}

@end
