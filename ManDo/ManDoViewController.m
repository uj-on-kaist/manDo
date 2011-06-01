//
//  ManDoViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "ManDoViewController.h"

#import "MessageTableViewCell.h"

#import "Three20/Three20+Additions.h"

#import "UserInfoContainer.h"

#import "ASIHTTPRequest.h"
#import "NSDictionary_JSONExtensions.h"


#import "QueryDetailView.h"
@implementation ManDoViewController

@synthesize _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        items=[[NSMutableArray alloc] init];
        if([[UserInfoContainer sharedInfo] isMale]){
            [self getQuerys];
        }
        
        self.title=@"Query";
        self.tabBarItem.image=[UIImage imageNamed:@"history.png"];
        
        
        
        self.view.backgroundColor=[UIColor whiteColor];
        if(![[UserInfoContainer sharedInfo] isMale]){
            self.navigationItem.rightBarButtonItem=nil;
        }
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
        
        
        
        TTButton *mapBtn=[TTButton buttonWithStyle:@"main_tab_btn:" title:@"       지도"];
        mapBtn.frame=CGRectMake(163, 5, 150, 34);
        mapBtn.font=[UIFont boldSystemFontOfSize:13.0f];
        [mapBtn addTarget:self action:@selector(mapBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [tab addSubview:mapBtn];
        
        UIImageView *imageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"world2.png"]];
        imageView2.frame=CGRectMake(40, 7, 16, 16);
        [mapBtn addSubview:imageView2];
        
        
        [self recentBtnClicked];
        cover=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        cover.backgroundColor=(UIColor *)TTSTYLE(backgroundColor);
        
        
        //[cover addTarget:self action:@selector(composeNew) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *compose=[UIButton buttonWithType:UIButtonTypeCustom];
        compose.frame=CGRectMake(130, 103, 60, 60);
        [compose setImage:[UIImage imageNamed:@"add_new.jpg"] forState:UIControlStateNormal];
        [compose addTarget:self action:@selector(composeNew) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:compose];
        
        [self.view addSubview:cover];
        
        
        
    }
    return self;
}
-(void)getQuerys{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",QUERY_LIST_URL,[[UserInfoContainer sharedInfo] phone]]]];
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
        [HUD hide:YES];
        [self showHUD:[error localizedDescription] type:TYPE_ERROR];
        NSLog(@"%@",[error localizedDescription]);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    cover.hidden=YES;
    if(![[UserInfoContainer sharedInfo] isMale]){
        
        /*
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeNew)];
        */
        cover.hidden=NO;
        return;
    }
    if([[UserInfoContainer sharedInfo] isMale]){
        [self getQuerys];
        [_tableView reloadData];
    }
    
    
}

- (void)dealloc
{
    [super dealloc];
}


-(void)composeNew{
    //[[UserInfoContainer sharedInfo] addGirl:@"123"];
    //return;
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://upload/message"];
	[action setAnimated:YES];
	[[TTNavigator navigator] openURLAction:action];
}

-(void)recentBtnClicked{
    if(_mapView != nil){_mapView.hidden=YES;}
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

-(void)mapBtnClicked{
    if(_tableView != nil){_tableView.hidden=YES;}
    if(_mapView == nil){
        _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 39, 320, self.view.frame.size.height-39)];
        //_map.showsUserLocation=YES;
        //_mapView.delegate=self;
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = 36.371638;
        newRegion.center.longitude = 127.360894;
        newRegion.span.latitudeDelta = 0.006878;
        newRegion.span.longitudeDelta = 0.013335;
        [_mapView setRegion:newRegion animated:YES];
        [self.view addSubview:_mapView];
    }
    _mapView.hidden=NO;
}


#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://query/detail"] 
                             applyQuery:[NSDictionary dictionaryWithObject:[items objectAtIndex:indexPath.row] forKey:@"item"]]
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
    msgLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                                                 [item objectForKey:@"phone"], 
                                                 [item objectForKey:@"phone"], 
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
    
    [cell setMsgText:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                      [item objectForKey:@"phone"], 
                      [item objectForKey:@"phone"], 
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
    
    [self performSelector:@selector(getQuerys) withObject:nil afterDelay:0.1];
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
