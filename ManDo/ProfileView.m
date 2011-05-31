//
//  ProfileView.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 30..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "ProfileView.h"

@implementation ProfileView

@synthesize info, delegate, profile;

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        info=[[NSMutableDictionary alloc] init];
        
        [self prepareView];
    }
    return self;
}


-(void)dealloc{
    [profile release];
    [info release];
    [delegate release];
    [super dealloc];
}

-(void)prepareView{
    self.backgroundColor=(UIColor *)TTSTYLE(backgroundColor);
    
    UIView *container=[[UIView alloc] init];
    container.backgroundColor=[UIColor whiteColor];
    container.layer.cornerRadius=10.0f;
    container.layer.borderWidth=1.0f;
    container.layer.borderColor=[UIColor grayColor].CGColor;
    container.frame=CGRectMake(10, 10, 300, 150);
    [self addSubview:container];
    
    
    
    TTView *profileWrapper=[[TTView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    profileWrapper.backgroundColor=[UIColor clearColor];
    
    profile=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"female.png"]];
    profile.frame=CGRectMake(10, 10, 100, 100);
    profile.layer.cornerRadius=10.0f;
    profile.clipsToBounds=YES;
    
    profileWrapper.clipsToBounds=YES;
    profileWrapper.style=[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
                          [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:
                           [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:6 offset:CGSizeMake(1, 1) next:
                            [TTSolidBorderStyle styleWithColor:RGBCOLOR(158, 163, 172) width:1 next:nil]]]];
    [container addSubview:profile];
    [container addSubview:profileWrapper];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, 10, 100, 100);
    [container addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    //여자 ♀",@"남자 ♂
    UILabel *gender=[[UILabel alloc] initWithFrame:CGRectMake(120, 25, 170, 24)];
    gender.text=@"여자 ♀";
    gender.textColor=RGBCOLOR(70, 105, 100);
    gender.font=[UIFont boldSystemFontOfSize:18.0f];
    
    [container addSubview:gender];
    
    UILabel *age=[[UILabel alloc] initWithFrame:CGRectMake(185, 29, 70, 20)];
    age.text=@"23세";
    age.textColor=[UIColor darkGrayColor];
    age.font=[UIFont boldSystemFontOfSize:14.0f];
    [container addSubview:age];
    
    UILabel *dept=[[UILabel alloc] initWithFrame:CGRectMake(120, 54, 170, 20)];
    dept.text=@"전산학과";
    dept.textColor=[UIColor darkGrayColor];
    dept.font=[UIFont boldSystemFontOfSize:14.0f];
    [container addSubview:dept];
    
    UILabel *phone=[[UILabel alloc] initWithFrame:CGRectMake(120, 74, 170, 20)];
    phone.text=@"010-5710-6299";
    phone.textColor=[UIColor darkGrayColor];
    phone.font=[UIFont boldSystemFontOfSize:14.0f];
    [container addSubview:phone];
    
    
    TTView *speech=[[TTView alloc] initWithFrame:CGRectMake(10, 115, 210, 25)];
    speech.backgroundColor=[UIColor clearColor];
    speech.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:5 pointLocation:66
                                                                        pointAngle:90
                                                                         pointSize:CGSizeMake(10,5)] next:
                  [TTSolidFillStyle styleWithColor:RGBCOLOR(54, 54, 54) next:
                   [TTSolidBorderStyle styleWithColor:RGBCOLOR(34, 34, 34) width:0.5 next:nil]]];
    UILabel *caption=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 210, 20)];
    caption.text=@"클릭하여 프로필 사진을 등록하세요!";
    caption.font=[UIFont boldSystemFontOfSize:12.0f];
    caption.textColor=[UIColor whiteColor];
    caption.backgroundColor=[UIColor clearColor];
    caption.textAlignment=UITextAlignmentCenter;
    [speech addSubview:caption];
    [container addSubview:speech];
    
    
    TTButton *submit=[TTButton buttonWithStyle:@"embossedButton:" title:@"등록하기"];
    submit.frame=CGRectMake(10, 170, 300, 36);
    submit.font=[UIFont boldSystemFontOfSize:14.0f];
    [submit addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submit];
    
}
-(void)registerClicked{
    NSMutableDictionary *infos=[[NSMutableDictionary alloc] init];
    //NSData* imageData=UIImagePNGRepresentation(profile.image);
    [delegate clickRegisterButton:infos];
    
}
-(void)btnClicked{
    if([delegate respondsToSelector:@selector(clickProfileButton)])
        [delegate clickProfileButton];
}



@end
