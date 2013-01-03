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
#import "LogUtils.h"

@interface PreferencesController : NSWindowController {
    NSUserDefaults *preferences;
}

- (double) pollInterval;
- (id) getUserDefault:(NSString *)prefKey;
- (void) setUserDefault:(NSObject *)object forKey:(NSString *)prefKey;
- (NSString *) getUUID;

@end
