//
//  QueryDetailView.h
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "EGOImageView.h"

#import "MBProgressHUD.h"

#import <MapKit/MapKit.h>

#import "QueryMarker.h"

@interface LikeButton : UIButton {
    NSString *answer_id;
}
@property (nonatomic, retain) NSString *answer_id;
@end

@interface QueryDetailView : TTViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary *item;
    
    UITableView *_tableView;
    
    NSMutableArray *items;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSMutableDictionary *item;

-(void)displayAnswers;


-(void *)showHUD:(NSString *)message type:(int)type;


@end
