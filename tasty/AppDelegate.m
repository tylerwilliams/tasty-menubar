//
//  AppDelegate.m
//  tasty
//
//  Created by Tyler Williams on 12/26/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuController.h"
#import "AppWatcher.h"
#import "TasteRecorder.h"
#import "ASLLogger.h"
#import "MoveProxy.h"

@implementation AppDelegate

@synthesize menuController;
@synthesize preferencesController;
@synthesize appWatcher;
@synthesize tasteRecorder;

- (void) killAllDefaults {
    // helper function to wipe out any NSUserDefaults and simulate a "fresh first run" in development
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d removeObjectForKey:@"moveToApplicationsFolderAlertSuppress"];
    [d removeObjectForKey:@"watchItunes"];
    [d removeObjectForKey:@"watchSpotify"];
    [d removeObjectForKey:@"watchRdio"];
    [d removeObjectForKey:@"incognitoMode"];
    [d removeObjectForKey:@"prevStartupVersions"];
//    [d removeObjectForKey:@"UUID"];
    
    LaunchAtLoginController *l = [LaunchAtLoginController new];
    [l setLaunchAtLogin:FALSE];
    NSLog(@"reset defaults!");
    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /* 
     try move ourself to /Applications if we're not there;
     this call will not return if the move is successful
     */
    MoveProxy *m = [MoveProxy new];
    [m moveOrDie];
    
    // setup logging
    [ASLLogger setFacility:[[NSBundle mainBundle] bundleIdentifier]];
    
    [[LogUtils tastyLogger] info:[NSString stringWithFormat:@"starting %@ (version %@ build %@)", [[NSBundle mainBundle] bundleIdentifier],
          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
          ]];
    
#ifdef DEBUG
    [self killAllDefaults];
#endif
    
    // assemble our application and start it
    preferencesController = [[PreferencesController alloc] init];
    appWatcher = [[AppWatcher alloc] initWithPrefsController:preferencesController];
    tasteRecorder = [[TasteRecorder alloc] initWithPrefsController:preferencesController];
	if (menuController == nil) {
        menuController = [[MenuController alloc] initWithPrefsWatcher:preferencesController
                                                    withAppController:appWatcher
                                                    withtasteRecorder:tasteRecorder];
    }
	[menuController showWindow:nil];
}

@end

