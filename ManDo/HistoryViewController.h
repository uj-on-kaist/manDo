//
//  HistoryViewController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

#import "EGORefreshTableHeaderView.h"

#import "MBProgressHUD.h"

@interface HistoryViewController : TTViewController <EGORefreshTableHeaderDelegate,UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSMutableArray *items;
    
    UIView *profileView;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) UITableView *_tableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)recentBtnClicked;

-(void)getHistory;

-(void *)showHUD:(NSString *)message type:(int)type;
@end
