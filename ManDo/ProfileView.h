//
//  ProfileView.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 30..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "Three20/Three20.h"



@protocol ProfileViewDelegate <NSObject>

@required
-(void)clickProfileButton;
-(void)clickRegisterButton:(NSMutableDictionary *)info;
@end


@interface ProfileView : TTView{
    NSMutableDictionary *info;
    
    UIImageView *profile;
    id<ProfileViewDelegate> delegate;
    
    
}
@property (assign) id<ProfileViewDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *info;
@property (nonatomic, retain) UIImageView *profile;

-(void)prepareView;
@end
