//
//  HUDShowMaker.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "HUDShowMaker.h"


@implementation HUDShowMaker

+(MBProgressHUD *)showHUD:(id)delegate forView:(id)view{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	
    // Add HUD to screen
    //[self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = delegate;
	
    HUD.labelText = @"Loading";
    //HUD.detailsLabelText = @"updating data";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    
    return HUD;
}


+(void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        //HUD.progress = progress;
        usleep(50000);
    }
}

+(void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
    // Labels can be changed during the execution
    //HUD.detailsLabelText = @"Something";
    //sleep(3);
}

@end
