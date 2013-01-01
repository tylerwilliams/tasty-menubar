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
            [logger warn:[NSString stringWithFormat:@"Create directory error: %@", error]];
        }
    }
}

- (NSFileHandle *) getFileHandle: (NSString *) filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(handle == nil) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    } else {
        [handle seekToEndOfFile];
    }
    return handle;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /* 
     try move ourself to /Applications if we're not there;
     this call will not return if the move is successful
     */
    MoveProxy *m = [MoveProxy new];
    [m moveOrDie];
    
    // make our logging directory if it doesn't yet exist
    NSString *logDir = [self logDirectory];
    [self mkdirP:logDir];
    
    // setup logging
    [ASLLogger setFacility:[[NSBundle mainBundle] bundleIdentifier]];
    logger = [ASLLogger loggerForModule:@"main"];
    // log to ~/Library/logs/Tasty/tasty.log
    [logger addFileHandle:[self getFileHandle:[logDir stringByAppendingPathComponent:@"tasty.log"]]];
    // log to stderr
    [logger addFileHandle:[NSFileHandle fileHandleWithStandardError]];
    // debug level
    logger.connection.level = ASLLoggerLevelDebug;
    
    [logger info:[NSString stringWithFormat:@"starting %@ (version %@ build %@)", [[NSBundle mainBundle] bundleIdentifier],
          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
          ]];
    
#ifdef DEBUG
    [self killAllDefaults];
#endif
    
    // assemble our application and start it
    preferencesController = [[PreferencesController alloc] init];
    appWatcher = [[AppWatcher alloc] initWithPrefsController:preferencesController withLogger:logger];
    tasteRecorder = [[TasteRecorder alloc] initWithPrefsController:preferencesController withLogger:logger];
	if (menuController == nil) {
        menuController = [[MenuController alloc] initWithPrefsWatcher:preferencesController
                                                    withAppController:appWatcher
                                                    withtasteRecorder:tasteRecorder
                                                           withLogger:logger];
    }
	[menuController showWindow:nil];
}



@end

