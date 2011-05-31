//
//  SettingViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SettingViewController.h"


@implementation SettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"Setting";
        self.tabBarItem.image=[UIImage imageNamed:@"setting.png"];
        
        self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
        
        
        _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-39) style:UITableViewStyleGrouped] autorelease];
        _tableView.backgroundColor=(UIColor *)TTSTYLE(profile_bg_color);
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        [self.view addSubview:_tableView];
        
        TTView *headerView=[[TTView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        headerView.backgroundColor=RGBCOLOR(48, 44, 41);
        TTView *speech=[[TTView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-20, 320, 10)];
        speech.backgroundColor=[UIColor clearColor];
        speech.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:5 pointLocation:54
                                                                            pointAngle:90
                                                                             pointSize:CGSizeMake(20,10)] next:[TTSolidFillStyle styleWithColor:_tableView.backgroundColor next:nil]];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-10, 320, 10)];
        view.backgroundColor=_tableView.backgroundColor;
        [headerView addSubview:view];
        [headerView addSubview:speech];
        [_tableView setTableHeaderView:headerView];
    }
    return self;
}

-(void)logout{
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://signin"];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     TTURLAction *action = [TTURLAction actionWithURLPath:[links objectAtIndex:indexPath.row]];
     [action setAnimated:YES];
     [[TTNavigator navigator] openURLAction:action];*/
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    return 1;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return 47;
 }
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    if(!(cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier])){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    if(indexPath.section == 0)
        cell.textLabel.text=@"Add to my Favorites";
    else
        cell.textLabel.text=@"Help";
    cell.textLabel.textColor=RGBCOLOR(70, 105, 100);
    cell.textLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell.detailTextLabel.text=@"전산학과";
    
    return cell;
    
}


@end
