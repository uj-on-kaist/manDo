//
//  QueryDetailView.m
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "QueryDetailView.h"
#import "Three20/Three20+Additions.h"

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
        
        
        TTView *profileContainer=[[TTView alloc] initWithFrame:CGRectMake(5, 5, 34,34)];
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
        [self.view addSubview:profileContainer];
        
        
        TTStyledTextLabel *msgLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(44, 5, 260, 30)] autorelease];
        msgLabel.text = [TTStyledText textFromXHTML:@"Hello" lineBreaks:YES URLs:YES];
        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.textColor = [UIColor darkTextColor];
        //msgLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [msgLabel sizeToFit];
        
        [self.view addSubview:msgLabel];
        
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 320, 14)];
        dateLabel.text=@"";
        dateLabel.font=[UIFont systemFontOfSize:12.0f];
        dateLabel.textColor=[UIColor grayColor];
        [self.view addSubview:dateLabel];
        
        
        UIImageView *geoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinSmall.png"]];
        geoView.frame=CGRectMake(295, 5, 16, 16);
        [self.view addSubview:geoView];
        
        
        
        msgLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"tt://profile/%@\">%@</a> %@", 
                                                     [item objectForKey:@"phone"], 
                                                     [item objectForKey:@"phone"], 
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
        
        
        dateLabel.frame=CGRectMake(44, msgLabel.frame.size.height+8, 320, 14);
        
    }
    return self;
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
    //TTURLAction *action = [TTURLAction actionWithURLPath:@"tt://query/detail" ];
    [action setAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

@end
