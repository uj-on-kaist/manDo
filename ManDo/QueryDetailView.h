//
//  QueryDetailView.h
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "EGOImageView.h"

@interface QueryDetailView : TTViewController <UITextFieldDelegate>{
    NSMutableDictionary *item;
}

@property (nonatomic, retain) NSMutableDictionary *item;

@end
