//
//  HistoryViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "HistoryViewController.h"

#import "MessageTableViewCell.h"
#import "Three20/Three20+Additions.h"

#import "UserInfoContainer.h"

#import "ASIHTTPRequest.h"
#import "NSDictionary_JSONExtensions.h"

@implementation HistoryViewController


@synthesize _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        items=[[NSMutableArray alloc] init];
        [self getHistory];
        
        // Custom initialization
        self.title=@"History";
        self.tabBarItem.image=[UIImage imageNamed:@"calendar.png"];
        
        
        TTView *tab=[[TTView alloc] initWithFrame:CGRectMake(0, 0, 320, 39)];
        tab.style=TTSTYLE(main_tab);
        [self.view addSubview:tab];
        
        
        TTButton *latestBtn=[TTButton buttonWithStyle:@"main_tab_btn:" title:@"       최근"];
        latestBtn.frame=CGRectMake(8, 5, 150, 34);
        latestBtn.font=[UIFont boldSystemFontOfSize:13.0f];
        [tab addSubview:latestBtn];
        [latestBtn addTarget:self action:@selector(recentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar2.png"]];
        imageView1.frame=CGRectMake(40, 7, 16, 16);
        [latestBtn addSubview:imageView1];
        
        
        
        TTButton *mapBtn=[TTButton buttonWithStyle:@"main_tab_btn:" title:@"       마이"];
        mapBtn.frame=CGRectMake(163, 5, 150, 34);
        mapBtn.font=[UIFont boldSystemFontOfSize:13.0f];
        [mapBtn addTarget:self action:@selector(profileBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [tab addSubview:mapBtn];
        
        UIImageView *imageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"world2.png"]];
        imageView2.frame=CGRectMake(40, 7, 16, 16);
        [mapBtn addSubview:imageView2];
        
        
        [self recentBtnClicked];
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[UserInfoContainer sharedInfo] phone]){
        [self getHistory];
        [self getProfileChart];
    }
    

}
-(void)getHistory{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_HISTORY_URL,[[UserInfoContainer sharedInfo] phone]]]];
    NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_HISTORY_URL,[[UserInfoContainer sharedInfo] phone]]]);
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                //NSLog(@"CODE:1");
            }else{                
                //TODO: SHOW _ QUERY LIST
                [items removeAllObjects];
                NSArray *array=[NSArray arrayWithArray:[resultDict objectForKey:@"querys"]];
                for(int i=0; i<[array count]; i++){
                    [items insertObject:[array objectAtIndex:i] atIndex:i];
                }
                
                if(_tableView != nil)
                    [_tableView reloadData];
                
                //[items insertObjects:array atIndexes:[NSIndexSet indexSetWithIndex:0]];
                return;
            }
        }else{
            NSLog(@"Original response: %@",response);
        }
    }else{
        [self showHUD:[error localizedDescription] type:TYPE_ERROR];
        NSLog(@"%@",[error localizedDescription]);
    }
}

-(void)recentBtnClicked{
    if(profileView != nil){profileView.hidden=YES;}
    if(_tableView == nil){
        _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 39, 320, self.view.frame.size.height-39-48) style:UITableViewStylePlain] autorelease];
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
        
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self._tableView.bounds.size.height, self.view.frame.size.width, self._tableView.bounds.size.height)];
            view.delegate = self;
            [self._tableView addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
        
    }
    _tableView.hidden=NO;
}

-(void)profileBtnClicked{
    if(_tableView != nil){_tableView.hidden=YES;}
    if(profileView == nil){
        profileView=[[UIView alloc] initWithFrame:CGRectMake(0, 39, 320, self.view.frame.size.height-39-48)];
        profileView.backgroundColor=(UIColor *)TTSTYLE(backgroundColor);
        [self.view addSubview:profileView];

        
        chartView=[[EGOImageView alloc] init];
        chartView.frame=CGRectMake(10, 10, 300, 120);
        [profileView addSubview:chartView];
        
        
    }
    
    [self getProfileChart];
    profileView.hidden=NO;
    
}

-(void)getProfileChart{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_CHART_URL,[[UserInfoContainer sharedInfo] phone]]]];
    NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_CHART_URL,[[UserInfoContainer sharedInfo] phone]]]);
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                //NSLog(@"CODE:1");
            }else{                
                //[NSURL URLWithString:[resultDict objectForKey:@"url"]]
                if(![[UserInfoContainer sharedInfo] isMale]){
                    chartView.imageURL=[NSURL URLWithString:[resultDict objectForKey:@"url"]];
                }else{
                    NSString *urlStr=[resultDict objectForKey:@"url"];
                    
                    NSArray *chunks = [urlStr componentsSeparatedByString: @"chl="];
                    if([chunks count] < 2){
                        return;
                    }
                    NSString *chl=[chunks objectAtIndex:1];
                    NSArray *ids=[chl componentsSeparatedByString:@"%7c"];
                    
                    NSLog(@"%@",ids);
                    
                    
                    NSString *changedURLStr=[NSString stringWithFormat:@"%@chl=",[chunks objectAtIndex:0]];
                    
                    for(int i=0; i<[ids count]; i++){
                        changedURLStr=[changedURLStr stringByAppendingFormat:@"%@|",[[UserInfoContainer sharedInfo] getGirlName:[ids objectAtIndex:i]]];
                    }
                    
                    
                    NSLog(@"changed: %@",changedURLStr);

                    chartView.imageURL=[NSURL URLWithString:[changedURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                }//[items insertObjects:array atIndexes:[NSIndexSet indexSetWithIndex:0]];
                //chartView.imageURL=[NSURL URLWithString:[resultDict objectForKey:@"url"]];
            }
        }else{
            NSLog(@"Original response: %@",response);
        }
    }else{
        NSLog(@"%@",[error localizedDescription]);
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *item=[[NSMutableDictionary alloc] initWithDictionary:[items objectAtIndex:indexPath.row]];
    if([[UserInfoContainer sharedInfo] isMale]){
        [item setObject:@"historyMale" forKey:@"callType"];
    }else{
        [item setObject:@"historyFemale" forKey:@"callType"];
    }
    
    //Get Answer
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@&query_id=%@",GET_ANSWER_URL,[[UserInfoContainer sharedInfo] phone],[item objectForKey:@"query_id"]]]];
    NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@&query_id=%@",GET_ANSWER_URL,[[UserInfoContainer sharedInfo] phone], [item objectForKey:@"query_id"]]]);
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                //NSLog(@"CODE:1");
            }else{                
                //TODO: SHOW _ QUERY LIST
                [item setObject:[resultDict objectForKey:@"answers"] forKey:@"answers"];
            }
        }else{
            NSLog(@"Original response: %@",response);
        }
    }else{
        [self showHUD:[error localizedDescription] type:TYPE_ERROR];
        NSLog(@"%@",[error localizedDescription]);
    }
    
    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://query/detail"] 
                             applyQuery:[NSDictionary dictionaryWithObject:item forKey:@"item"]]
                            applyAnimated:YES];
    //TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://query/detail" ];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item=[items objectAtIndex:indexPath.row];
    TTStyledTextLabel *msgLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(44, 5, 260, 30)] autorelease];
    
    NSString *user_name=[[UserInfoContainer sharedInfo] name];
    if([[UserInfoContainer sharedInfo] isMale]){
        user_name=[[UserInfoContainer sharedInfo] getGirlName:[item objectForKey:@"phone"]];
    }
    msgLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                                                 [item objectForKey:@"phone"], 
                                                 user_name, 
                                                 [item objectForKey:@"message"]]
                                     lineBreaks:YES URLs:YES];
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.textColor = [UIColor darkTextColor];
    [msgLabel sizeToFit];
    return msgLabel.frame.size.height+30;
    //return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"message";
    
    MessageTableViewCell *cell;
    if(!(cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier])){
        cell=[[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //[cell.profileView setImageURL:[NSURL URLWithString:@"http://www.google.co.kr/images/nav_logo72.png"]];
    
    NSMutableDictionary *item=[items objectAtIndex:indexPath.row];
    
    
    NSString *user_name=[[UserInfoContainer sharedInfo] name];
    if([[UserInfoContainer sharedInfo] isMale]){
        user_name=[[UserInfoContainer sharedInfo] getGirlName:[item objectForKey:@"phone"]];
        cell.profileView.image=[UIImage imageNamed:@"female.png"];

    }else{
        cell.profileView.imageURL=[NSURL URLWithString:[[UserInfoContainer sharedInfo] getUserPicture:[item objectForKey:@"phone"]]];
    }
    [cell setMsgText:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                      [item objectForKey:@"phone"], 
                      user_name, 
                      [item objectForKey:@"message"]]];
    
    cell.photoView.hidden=YES;
    if([[item objectForKey:@"lat"] intValue] == 0 || [[item objectForKey:@"lng"] intValue] == 0){
        cell.geoView.hidden=YES;
    }
    
    NSString *date=[item objectForKey:@"reg_date"];
    NSArray *chunks = [date componentsSeparatedByString: @"."];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *myDate = [dateFormatter dateFromString:[chunks objectAtIndex:0]];
    //NSLog(@"%@",[chunks objectAtIndex:0]);
    cell.dateLabel.text=[myDate formatRelativeTime];
    
    return cell;
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    _reloading = YES;
    
    [self performSelector:@selector(getHistory) withObject:nil afterDelay:0.1];
    //[self performSelector:@selector(getList) withObject:nil afterDelay:0.1];
}
- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self._tableView];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
	
}



-(void *)showHUD:(NSString *)message type:(int)type{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    if(type != TYPE_LOADING){
        NSString *filename=@"errorHUD.png";
        
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = message;
    }
    
    //HUD.labelText = @"Loading";
    
    [self.navigationController.view addSubview:HUD];
    
    if(type == TYPE_LOADING)
        [HUD showWhileExecuting:@selector(longTask) onTarget:self withObject:nil animated:YES];
    else
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    return HUD;
}
-(void)myTask {
    sleep(1);
}
-(void)longTask{
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        //HUD.progress = progress;
        usleep(50000);
    }
}

@end
