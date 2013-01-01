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
#import "ASLLogger.h"
#import "MoveProxy.h"

@implementation AppDelegate

@synthesize menuController;
@synthesize preferencesController;
@synthesize appWatcher;
@synthesize tasteLogger;

- (void) killAllDefaults {
    // helper function to wipe out any NSUserDefaults and simulate a "fresh first run" in development
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d removeObjectForKey:@"moveToApplicationsFolderAlertSuppress"];
    [d removeObjectForKey:@"watchItunes"];
    [d removeObjectForKey:@"watchSpotify"];
    [d removeObjectForKey:@"watchRdio"];
    [d removeObjectForKey:@"incognitoMode"];
    
    LaunchAtLoginController *l = [LaunchAtLoginController new];
    [l setLaunchAtLogin:FALSE];
    NSLog(@"reset defaults!");
    
}

- (NSString *) logDirectory {    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
		return [[[paths objectAtIndex:0]
				  stringByAppendingPathComponent:@"Logs"]
                stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
	}
	
	NSAssert(NO, @"Could not find ~/Library/Logs directory.");
	return nil;
}

- (void) mkdirP: (NSString *) filePathAndDirectory {
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePathAndDirectory]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    #ifdef DEBUG
    [self killAllDefaults];
    #endif
    
    /* 
     try move ourself to /Applications if we're not there;
     this call will not return if the move is successful
     */
    MoveProxy *m = [MoveProxy new];
    [m moveOrDie];
    
    // make our logging directory if it doesn't yet exist
    NSString *logDir = [self logDirectory];
    [self mkdirP:logDir];
    
    // setup + test logging
    [ASLLogger setFacility:[[NSBundle mainBundle] bundleIdentifier]];
    logger = [ASLLogger loggerForModule:@"appDelegate"];
    [logger addFileHandle:[NSFileHandle fileHandleWithStandardError]];
    [logger addFileHandle:[NSFileHandle fileHandleForUpdatingAtPath:[logDir stringByAppendingPathComponent:@"tasty.log"]]];
    logger.connection.level = ASLLoggerLevelDebug;
    [logger debug:@"This message is a debug-level message"];
    [logger warn:@"This message is a warn-level message"];
    NSLog(@"starting %@ (version %@ build %@)", [[NSBundle mainBundle] bundleIdentifier],
          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
          );
    
    // assemble our application and start it
    preferencesController = [[PreferencesController alloc] init];
    appWatcher = [[AppWatcher alloc] initWithPrefsController:preferencesController];
    tasteLogger = [[TasteLogger alloc] initWithPrefsController:preferencesController];
	if (menuController == nil) {
        menuController = [[MenuController alloc] initWithPrefsWatcher:preferencesController withAppController:appWatcher withtasteLogger:tasteLogger];
    }
	[menuController showWindow:nil];
}



@end

