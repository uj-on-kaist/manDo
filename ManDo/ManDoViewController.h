//
//  ManDoViewController.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Three20/Three20.h"
#import "EGORefreshTableHeaderView.h"

#import <MapKit/MapKit.h>

@interface ManDoViewController : TTViewController <EGORefreshTableHeaderDelegate,UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    MKMapView *_mapView;
}
@property (nonatomic, retain) UITableView *_tableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)recentBtnClicked;
-(void)mapBtnClicked;
@end
