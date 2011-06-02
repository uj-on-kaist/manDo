//
//  QueryDetailView.m
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "QueryDetailView.h"
#import "Three20/Three20+Additions.h"

#import "MessageTableViewCell.h"


#import "ASIHTTPRequest.h"
#import "NSDictionary_JSONExtensions.h"

#import "UserInfoContainer.h"
@implementation LikeButton

@synthesize answer_id;

@end

@implementation QueryDetailView

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=(UIColor *)TTSTYLE(backgroundColor);
        
    }
    return self;
}

- (id) initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    self = [super init];
    if (self != nil) {
        
        items=[[NSMutableArray alloc] init];
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,320, self.view.frame.size.height-39)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
        
        self.item = [query objectForKey:@"item"];
        NSLog(@"%@",self.item);
        
        self.title=[item objectForKey:@"message"];
        
        TTView *bg=[[TTView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40-48, 320, 40)];
        bg.backgroundColor=(UIColor *)TTSTYLE(navigationBarTintColor);
        
        
        TTButton *btn=[TTButton buttonWithStyle:@"answerButton:" title:@"답변을 등록하세요!"];
        btn.frame=CGRectMake(10, 5, 300, 30);
        btn.font=[UIFont boldSystemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(composeNew) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
        
        [self.view addSubview:bg];
        
        TTView *queryWrapper=[[TTView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        [self.view addSubview:queryWrapper];
        TTView *profileContainer=[[TTView alloc] initWithFrame:CGRectMake(5, 10, 34,34)];
        //profileContainer.clipsToBounds=YES;
        //profileContainer.layer.cornerRadius=10.0f;
        //profileContainer.layer.borderWidth=1.0f;
        //profileContainer.layer.borderColor=[UIColor grayColor].CGColor;
        /*profileContainer.style=[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
         [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:
         [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:6 offset:CGSizeMake(1, 1) next:
         [TTSolidBorderStyle styleWithColor:RGBCOLOR(158, 163, 172) width:1 next:nil]]]];
         */
        
        EGOImageView *profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"female.png"] delegate:nil];
        profileView.frame=CGRectMake(0, 0, 34,34);
        profileView.contentMode=UIViewContentModeScaleToFill;
        
        [profileContainer addSubview:profileView];
        [queryWrapper addSubview:profileContainer];
        
        
        TTStyledTextLabel *msgLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(44, 10, 260, 30)] autorelease];
        msgLabel.text = [TTStyledText textFromXHTML:@"Hello" lineBreaks:YES URLs:YES];
        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.textColor = [UIColor darkTextColor];
        msgLabel.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
        //msgLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [msgLabel sizeToFit];
        
        [queryWrapper addSubview:msgLabel];
        
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 200, 14)];
        dateLabel.text=@"";
        dateLabel.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
        dateLabel.font=[UIFont systemFontOfSize:12.0f];
        dateLabel.textColor=[UIColor grayColor];
        [queryWrapper addSubview:dateLabel];
        
        
        UIImageView *geoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinSmall.png"]];
        geoView.frame=CGRectMake(295, 10, 16, 16);
        [queryWrapper addSubview:geoView];
        
        
        
        msgLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                                                     [item objectForKey:@"phone"], 
                                                     [[UserInfoContainer sharedInfo] getGirlName:[item objectForKey:@"phone"]], 
                                                     [item objectForKey:@"message"]] lineBreaks:YES URLs:YES];
        msgLabel.font = [UIFont systemFontOfSize:14];
        //msgLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [msgLabel sizeToFit];
        
        
        NSString *date=[item objectForKey:@"reg_date"];
        NSArray *chunks = [date componentsSeparatedByString: @"."];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *myDate = [dateFormatter dateFromString:[chunks objectAtIndex:0]];
        //NSLog(@"%@",[chunks objectAtIndex:0]);
        dateLabel.text=[myDate formatRelativeTime];
        
        dateLabel.frame=CGRectMake(44, msgLabel.frame.size.height+13, 180, 14);

        NSLog(@"%f",[[item objectForKey:@"lat"] floatValue]);
        if([[item objectForKey:@"lat"] floatValue] != 0 && [[item objectForKey:@"lng"] floatValue] != 0){
            if([[item objectForKey:@"lat"] floatValue]<39.0 && [[item objectForKey:@"lat"] floatValue]>0.0){
            
            queryWrapper.frame=CGRectMake(0, 0, 320, msgLabel.frame.size.height+155);
            
            MKMapView *_mapView=[[MKMapView alloc] initWithFrame:CGRectMake(44, msgLabel.frame.size.height+30, 240, 100)];
            [queryWrapper addSubview:_mapView];
            
            _mapView.layer.cornerRadius=15.0f;
            MKCoordinateRegion newRegion;
            newRegion.center.latitude = [[item objectForKey:@"lat"] floatValue];
            newRegion.center.longitude = [[item objectForKey:@"lng"] floatValue];
            newRegion.span.latitudeDelta = 0.005878;
            newRegion.span.longitudeDelta = 0.010335;
            [_mapView setRegion:newRegion animated:YES];
            
            QueryMarker *mapMarker=[[QueryMarker alloc] init];
            mapMarker.coordinate = newRegion.center;
            [_mapView addAnnotation:mapMarker];
            }else{
             queryWrapper.frame=CGRectMake(0, 0, 320, msgLabel.frame.size.height+55);
            }
        }else{
            queryWrapper.frame=CGRectMake(0, 0, 320, msgLabel.frame.size.height+55);
        }
        queryWrapper.backgroundColor=[UIColor whiteColor];
        queryWrapper.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:0 pointLocation:300
                                                                                  pointAngle:270
                                                                                   pointSize:CGSizeMake(20,10)] next:
                            [TTSolidFillStyle styleWithColor:[UIColor colorWithRed:234.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] next:
                             [TTSolidBorderStyle styleWithColor:RGBCOLOR(1, 1, 1) width:0.5 next:nil]]];;
        [_tableView setTableHeaderView:queryWrapper];
        if([[item objectForKey:@"callType"] isEqualToString:@"historyFemale"] || [[item objectForKey:@"callType"] isEqualToString:@"historyMale"]){
            bg.hidden=YES;
            [self displayAnswers];
        }
        if([[item objectForKey:@"callType"] isEqualToString:@"historyFemale"]){
            profileView.imageURL=[NSURL URLWithString:[[UserInfoContainer sharedInfo] getUserPicture:[[UserInfoContainer sharedInfo] phone]]];
        }
        
        
        
    }
    return self;
}

-(void)displayAnswers{
    NSArray *array = [item objectForKey:@"answers"];
    for(int i=0; i<[array count]; i++){
        NSDictionary *answer=[array objectAtIndex:i];
        NSLog(@"answer %d: %@",i,answer);
        [items addObject:answer];
    }
    [_tableView reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField resignFirstResponder];
    TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://upload/message"];
	[action setAnimated:YES];
	[[TTNavigator navigator] openURLAction:action];
}

-(void)composeNew{
    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://upload/message"] 
                             applyQuery:[NSDictionary dictionaryWithObject:item forKey:@"additional"]]
                            applyAnimated:YES];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *cell_item=[items objectAtIndex:indexPath.row];
    TTStyledTextLabel *msgLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(44, 5, 260, 30)] autorelease];
    msgLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                                                 [cell_item objectForKey:@"user_name"], 
                                                 [cell_item objectForKey:@"user_name"], 
                                                 [cell_item objectForKey:@"message"]]
                                     lineBreaks:YES URLs:YES];
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.textColor = [UIColor darkTextColor];
    [msgLabel sizeToFit];
    NSString *photoURL = [cell_item objectForKey:@"photo"];
    NSRange range = [photoURL rangeOfString :@"answer"];
    
    if (range.location != NSNotFound) {
        NSLog(@"I found something.");
        return msgLabel.frame.size.height+130;
    }
    
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
    
    NSMutableDictionary *cell_item=[items objectAtIndex:indexPath.row];
    
    [cell setMsgText:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                      [cell_item objectForKey:@"user_name"], 
                      [cell_item objectForKey:@"user_name"], 
                      [cell_item objectForKey:@"message"]]];
    
    cell.photoView.hidden=YES;
    if([[cell_item objectForKey:@"lat"] intValue] == 0 || [[cell_item objectForKey:@"lng"] intValue] == 0){
        cell.geoView.hidden=YES;
    }
    
    NSString *date=[cell_item objectForKey:@"reg_date"];
    NSArray *chunks = [date componentsSeparatedByString: @"."];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *myDate = [dateFormatter dateFromString:[chunks objectAtIndex:0]];
    //NSLog(@"%@",[chunks objectAtIndex:0]);
    cell.dateLabel.text=[myDate formatRelativeTime];
    
    
    LikeButton *likeButton=[LikeButton buttonWithType:UIButtonTypeCustom];
    if([[cell_item objectForKey:@"like"] intValue] == 0){
        [likeButton setImage:[UIImage imageNamed:@"icon_star_off.png"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"icon_star_off.png"] forState:UIControlStateDisabled];
    }else{
        [likeButton setImage:[UIImage imageNamed:@"icon_star_on.png"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"icon_star_on.png"] forState:UIControlStateDisabled];
    }
    
    likeButton.frame=CGRectMake(291, 5, 24, 24);
    
    if([[item objectForKey:@"callType"] isEqualToString:@"historyMale"]){
        likeButton.enabled=NO;
        [likeButton addTarget:self action:@selector(emptyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.profileView.imageURL=[NSURL URLWithString:[[UserInfoContainer sharedInfo] getUserPicture:[[UserInfoContainer sharedInfo] phone]]];
    }else if([[item objectForKey:@"callType"] isEqualToString:@"historyFemale"]){
        likeButton.answer_id=[cell_item objectForKey:@"answer_id"];
        likeButton.enabled=YES;
        [likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.profileView.imageURL=[NSURL URLWithString:[[UserInfoContainer sharedInfo] getUserPicture:[cell_item objectForKey:@"phone"]]];

    }
    
    
    [cell addSubview:likeButton];
    
    
    //UIImageView *img=[[UIImageView alloc] initWithImage:[]];
    //http://bit.sparcs.org:9999/media/answer/2
    
    NSString *photoURL = [cell_item objectForKey:@"photo"];
    NSRange range = [photoURL rangeOfString :@"answer"];
    
    if (range.location != NSNotFound) {
        NSLog(@"I found something.");
        cell.answerImageView.hidden=NO;
        cell.answerImageView.imageURL=[NSURL URLWithString:photoURL];
        cell.imageButton.hidden=NO;
    }
    return cell;
    
}

-(void)emptyAction:(id)sender{
    NSLog(@"emptyAction");
}
-(void)likeAction:(id)sender{
    LikeButton *button=(LikeButton *)sender;
    NSLog(@"likeAction");
    

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?answer_id=%@",LIKE_ANSWER_URL,button.answer_id]]];
    [self showHUD:@"Updating..." type:TYPE_LOADING];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        [HUD hide:YES];
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                //NSLog(@"CODE:1");
            }else{     
                NSMutableArray *temp_items=[[NSMutableArray alloc] init];
                for(int i=0; i<[items count];i++){
                    NSDictionary *cell_item = [items objectAtIndex:i];
                    NSMutableDictionary *temp_item = [[NSMutableDictionary alloc] initWithDictionary:cell_item];
                    if([[temp_item objectForKey:@"answer_id"] isEqualToString:button.answer_id]){
                        [temp_item setObject:@"1" forKey:@"like"];
                        [_tableView reloadData];
                    }
                    [temp_items addObject:temp_item];
                }
                items=[[NSMutableArray alloc]initWithArray:temp_items];
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
