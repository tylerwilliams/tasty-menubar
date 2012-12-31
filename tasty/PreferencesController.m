//
//  PreferencesController.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/19/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

- (void) setDefaults {
    // load the default prefs from "DefaultPrefs.plist"
    preferences = [NSUserDefaults standardUserDefaults];
    NSString *file = [[NSBundle mainBundle]
                      pathForResource:@"DefaultPrefs" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
    [preferences registerDefaults:dict];
    [preferences synchronize];
}

- (id) init {
    if(self = [super initWithWindowNibName:@"Preferences"]) {
        [self setDefaults];
        LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
        [launchController setLaunchAtLogin:YES];
    }
    return self;
}

- (double) pollInterval {
    NSNumber *pollingInterval = [[NSUserDefaults standardUserDefaults] objectForKey:@"pollingIntervalSeconds"];
    return [pollingInterval doubleValue];
}

- (id) getUserDefault:(NSString *)prefKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:prefKey];
}

- (NSString *) macAddressString {
    NICInfoSummary *summary = [[NICInfoSummary alloc] init];
    NICInfo* wifi_info = [summary findNICInfo:@"en0"];
    return [wifi_info getMacAddressWithSeparator:@"-"];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

@end
