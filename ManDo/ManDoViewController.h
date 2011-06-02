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


#import "MBProgressHUD.h"
@interface ManDoViewController : TTViewController <EGORefreshTableHeaderDelegate,UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate> {
    UITableView *_tableView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    MKMapView *_mapView;
    
    UIView *cover;
    
    MBProgressHUD *HUD;
    
    NSMutableArray *items;
}
@property (nonatomic, retain) UITableView *_tableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)recentBtnClicked;
-(void)mapBtnClicked;


-(void)addMarkers;
-(void *)showHUD:(NSString *)message type:(int)type;

-(void)getQuerys;

-(void)didSelectAnnotation:(NSDictionary *)item;
@end
