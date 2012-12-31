//
//  PreferencesController.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/19/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NICInfoSummary.h"
#import "LaunchAtLoginController.h"

@interface PreferencesController : NSWindowController {
    NSUserDefaults *preferences;
}

- (double) pollInterval;
- (id) getUserDefault:(NSString *)prefKey;
- (NSString *) macAddressString;

@end
