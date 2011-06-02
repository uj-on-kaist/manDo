//
//  MessageViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageViewController.h"

#import "UserInfoContainer.h"

@implementation MessageViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        array=[[NSMutableArray alloc] init];
        for(int i=0; i<10; i++){
            int current=(rand()%8);
            [array addObject:[NSNumber numberWithInt:current]];
        }
        // Custom initialization
        self.title=@"Girls";
        self.tabBarItem.image=[UIImage imageNamed:@"message.png"];
        
        
        _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-48) style:UITableViewStylePlain] autorelease];
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(![[UserInfoContainer sharedInfo] isMale]){
        self.title=@"Messages";
        _tableView.hidden=YES;
    }else{
        self.title=@"Girls";
        _tableView.hidden=NO;
    }
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TTURLAction *action =  [TTURLAction actionWithURLPath:@"tt://message/detail"];
    //TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://query/detail" ];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"message";
    
    UITableViewCell *cell;
    if(!(cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier])){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //[cell.profileView setImageURL:[NSURL URLWithString:@"http://www.google.co.kr/images/nav_logo72.png"]];
    
    
    for(UIView *view in [cell subviews])
        [view removeFromSuperview];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",indexPath.row]]];
    imageView.frame=CGRectMake(5, 5, 40, 40);
    imageView.layer.cornerRadius=5.0f;
    
    [cell addSubview:imageView];
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 20)];
    nameLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    if(indexPath.row<5)
        nameLabel.text=[NSString stringWithFormat:@"도도한 여자 %d호", (indexPath.row+1)];
    if(indexPath.row>8 || indexPath.row == 3)
        nameLabel.text=[NSString stringWithFormat:@"섹시한 여자 %d호", (indexPath.row+1)];
    if(indexPath.row>5 && indexPath.row < 8)
        nameLabel.text=[NSString stringWithFormat:@"귀여운 여자 %d호", (indexPath.row+1)];
    else
        nameLabel.text=[NSString stringWithFormat:@"섹시한 여자 %d호", (indexPath.row+1)];
    [cell addSubview:nameLabel];
    
    
    UILabel *stepLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 23, 200, 16)];
    stepLabel.font=[UIFont boldSystemFontOfSize:13.0f];
    stepLabel.textColor=[UIColor grayColor];
    
    int current=[[array objectAtIndex:indexPath.row] intValue];
    if(current>=6){
        [stepLabel setTextColor:[UIColor redColor]];
    }
    stepLabel.text=[NSString stringWithFormat:@"%d 단계 중 %d 단계!", 8, current];
    [cell addSubview:stepLabel];
    
    UIView *blockView=[[UIView alloc] initWithFrame:imageView.frame];
    blockView.backgroundColor=(UIColor *)TTSTYLE(navigationBarTintColor);
    
    CGRect frame=imageView.frame;
    frame.size.height*=((float)(8-current))/8.0f;
    blockView.frame=frame;
    [cell addSubview:blockView];
    
    return cell;
    
}
@end
