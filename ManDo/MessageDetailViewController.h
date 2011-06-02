//
//  MessageDetailViewController.h
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface ReflectedImageView : UIView 
{
@private
    UIImageView *_imageView;
    UIImageView *_imageReflectionView;
}

@property (nonatomic, retain) UIImage *image;

@end

@interface MessageDetailViewController : TTViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
}

@end