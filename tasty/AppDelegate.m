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
#import "TasteLogger.h"

@implementation AppDelegate

@synthesize menuController;
@synthesize preferencesController;
@synthesize appWatcher;
@synthesize tasteLogger;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    preferencesController = [[PreferencesController alloc] init];
    appWatcher = [[AppWatcher alloc] initWithPrefsController:preferencesController];
    tasteLogger = [[TasteLogger alloc] initWithPrefsController:preferencesController];
	if (menuController == nil) {
        menuController = [[MenuController alloc] initWithPrefsWatcher:preferencesController withAppController:appWatcher withtasteLogger:tasteLogger];
    }
	[menuController showWindow:nil];
}



@end

