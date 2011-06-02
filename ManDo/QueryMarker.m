//
//  QueryMarker.m
//  ManDo
//
//  Created by 정의준 on 11. 6. 2..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "QueryMarker.h"


@implementation QueryMarker
@synthesize coordinate, title, subtitle,index;

-(void) dealloc{
    [index release];
	[title release];
	[subtitle release];
	[super dealloc];
}
@end
