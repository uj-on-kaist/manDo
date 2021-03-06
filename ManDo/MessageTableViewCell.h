//
//  MessageTableViewCell.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "Three20/Three20.h"
@interface MessageTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    UILabel *nameLabel;
    UILabel *dateLabel;
    
    TTLabel *textView;
    
    TTStyledTextLabel *msgLabel;
    
    UIImageView *photoView;
    UIImageView *geoView;
    
    EGOImageView *answerImageView;
    
    UIButton *imageButton;
    
}

@property (nonatomic, retain) EGOImageView *profileView;
@property (nonatomic, retain) EGOImageView *answerImageView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *dateLabel;

@property (nonatomic, retain) TTLabel *textView;

@property (nonatomic, retain) TTStyledTextLabel *msgLabel;


@property (nonatomic, retain) UIImageView *photoView;

@property (nonatomic, retain) UIImageView *geoView;

@property (nonatomic, retain) UIButton *imageButton;
//nameLabel,dateLabel,textView,msgLabel

-(void)setMsgText:(NSString *)input;
@end
