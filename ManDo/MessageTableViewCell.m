//
//  MessageTableViewCell.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageTableViewCell.h"


@implementation MessageTableViewCell

@synthesize profileView,nameLabel,dateLabel,textView,msgLabel,geoView,photoView,answerImageView,imageButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
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
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"female.png"] delegate:nil];
        profileView.frame=CGRectMake(0, 0, 34,34);
        profileView.contentMode=UIViewContentModeScaleToFill;
        
        [profileContainer addSubview:profileView];
        [self addSubview:profileContainer];
        
        
        msgLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(44, 5, 260, 30)] autorelease];
        msgLabel.text = [TTStyledText textFromXHTML:@"Hello" lineBreaks:YES URLs:YES];
        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.textColor = [UIColor darkTextColor];
        //msgLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [msgLabel sizeToFit];
        
        [self addSubview:msgLabel];
        
        

        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 320, 14)];
        dateLabel.text=@"";
        dateLabel.font=[UIFont systemFontOfSize:12.0f];
        dateLabel.textColor=[UIColor grayColor];
        [self addSubview:dateLabel];
        
        
        photoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide.png"]];
        photoView.frame=CGRectMake(295, 26, 16, 16);
        [self addSubview:photoView];
        
        geoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinSmall.png"]];
        geoView.frame=CGRectMake(295, 5, 16, 16);
        [self addSubview:geoView];
        
        answerImageView = [[EGOImageView alloc] initWithPlaceholderImage:nil delegate:nil];
        answerImageView.frame=CGRectMake(44, 0, 80,80);
        answerImageView.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:answerImageView];
        answerImageView.hidden=YES;
        
        imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame=answerImageView.frame;
        [self addSubview:imageButton];
        imageButton.backgroundColor=RGBACOLOR(70, 105, 100,0.3);
        imageButton.hidden=YES;
        [imageButton addTarget:self action:@selector(openPicture) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}
-(void)openPicture{
    NSLog(@"%@",[answerImageView.imageURL absoluteString]);
    TTURLAction *action = [TTURLAction actionWithURLPath:[answerImageView.imageURL absoluteString]];
	[action setAnimated:YES];
	[[TTNavigator navigator] openURLAction:action];
}


-(void)setMsgText:(NSString *)input{
    msgLabel.text = [TTStyledText textFromXHTML:input lineBreaks:YES URLs:YES];
    msgLabel.font = [UIFont systemFontOfSize:14];
    //msgLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [msgLabel sizeToFit];
    
    
    dateLabel.frame=CGRectMake(44, msgLabel.frame.size.height+8, 320, 14);
    answerImageView.frame=CGRectMake(44, msgLabel.frame.size.height+30, 80,80);
    imageButton.frame=answerImageView.frame;
}



@end
