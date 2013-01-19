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
    // set the default value for unset preferences from "DefaultPrefs.plist"
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

- (void) setUserDefault:(NSObject *)object forKey:(NSString *)prefKey {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:prefKey];
}

- (NSString *)oldStyleUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}

- (NSString *) getUUID {
    NSString *uuidString = [self getUserDefault:@"UUID"];
    if (uuidString == nil) {
        uuidString = [self oldStyleUUID];
        [self setUserDefault:uuidString forKey:@"UUID"];
        [[LogUtils tastyLogger] info:[[NSString alloc] initWithFormat:@"UUID not found! setting initial UUID to: %@", uuidString]];
    }
    return uuidString;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

@end
