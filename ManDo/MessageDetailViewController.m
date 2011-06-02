//
//  MessageDetailViewController.m
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageDetailViewController.h"


@implementation ReflectedImageView

@dynamic image;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        self.backgroundColor = [UIColor clearColor];
        
        // This should be the size of your image:
        CGRect rect = CGRectMake(0.0, 0.0, 140.0, 140.0);
        
        _imageReflectionView = [[UIImageView alloc] initWithFrame:rect];
        _imageReflectionView.contentMode = UIViewContentModeScaleAspectFit;
        _imageReflectionView.alpha = 0.4;
        _imageReflectionView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 20.0);
        [self addSubview:_imageReflectionView];
        
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)newImage
{
    _imageView.image = newImage;
    _imageReflectionView.image = newImage;
}

- (UIImage *)image
{
    return _imageView.image;
}

- (void)dealloc 
{
    [_imageView release];
    [_imageReflectionView release];
    [super dealloc];
}

@end


@implementation MessageDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"섹시한 여자 2호";
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-48) style:UITableViewStyleGrouped];
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=(UIColor *)TTSTYLEVAR(tabTintColor);
        [self.view addSubview:_tableView];
        
        TTView *queryWrapper=[[TTView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        [self.view addSubview:queryWrapper];
        queryWrapper.backgroundColor=(UIColor *)TTSTYLEVAR(tabTintColor);
        queryWrapper.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:0 pointLocation:300
                                                                                  pointAngle:270
                                                                                   pointSize:CGSizeMake(20,10)] next:
                            [TTSolidFillStyle styleWithColor:RGBCOLOR(48, 44, 41) next:
                             [TTSolidBorderStyle styleWithColor:RGBCOLOR(1, 1, 1) width:0.5 next:nil]]];
        
        [_tableView setTableHeaderView:queryWrapper];
        
        ReflectedImageView *imageView=[[ReflectedImageView alloc] initWithFrame:CGRectMake(90, 10, 140, 140)];
        [imageView setImage:[UIImage imageNamed:@"test.png"]];
        [queryWrapper addSubview:imageView];
        
        UIView *blockView=[[UIView alloc] initWithFrame:imageView.frame];
        blockView.backgroundColor=(UIColor *)TTSTYLE(navigationBarTintColor);
        
        blockView.frame=CGRectMake(90, 10, 140, 140*0.48f);
        [queryWrapper addSubview:blockView];
        
        /*
        UIImageView *profile=[[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"test.png"]];
        [profile setFrame:CGRectMake(90, 10, 140, 140)];
        [queryWrapper addSubview:profile];
         */
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"message";
    
    UITableViewCell *cell;
    if(!(cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier])){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    cell.textLabel.textColor=(UIColor *)TTSTYLE(linkTextColor);
    if(indexPath.row == 0){
        cell.textLabel.text=@"과";
        
        cell.detailTextLabel.text=@"전산학과";
        
        cell.detailTextLabel.textColor=RGBCOLOR(1, 30, 91);
    }else if(indexPath.row == 1){
        cell.textLabel.text=@"나이";
        
        cell.detailTextLabel.text=@"23세";
        
        cell.detailTextLabel.textColor=RGBCOLOR(1, 30, 91);
    }else if(indexPath.row == 2){
        cell.textLabel.text=@"이름";
        
        cell.detailTextLabel.text=@"허XX      <- 현재 단계";
        
        cell.detailTextLabel.textColor=RGBCOLOR(1, 30, 91);
    }else if(indexPath.row == 3){
        cell.textLabel.text=@"전화번호";
        
        cell.detailTextLabel.text=@"XXX-XXX-XXXX";
        
        cell.detailTextLabel.textColor=[UIColor darkGrayColor];
    }
    return cell;
    
}
@end
