//
//  MenuController.m
//  tasty
//
//  Created by Tyler Williams on 12/26/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController

@synthesize statusBar = _statusBar;
@synthesize statusMenu = _statusMenu;
@synthesize preferencesController = _preferencesController;
@synthesize appWatcher = _appWatcher;
@synthesize statusItem = _statusItem;
@synthesize tasteLogger = _tasteLogger;

- (id)initWithPrefsWatcher:(PreferencesController *)p withAppController:(AppWatcher *)a withtasteLogger:(TasteLogger *)n {
    if (self = [super init]) {
        preferencesController = p;
        appWatcher = a;
        tasteLogger = n;
        [self detectFirstRun];
    }
    return self;
}

- (void) detectFirstRun {
    // Get current version ("Bundle Version") from the default Info.plist file
    NSString *currentVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil)
    {
        // Starting up for first time with NO pre-existing installs (e.g., fresh
        // install of some version)
        [self firstStartAfterFreshInstall];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentVersion] forKey:@"prevStartupVersions"];
    }
    else
    {
        if (![prevStartupVersions containsObject:currentVersion])
        {
            // Starting up for first time with this version of the app. This
            // means a different version of the app was alread installed once
            // and started.
            [self firstStartAfterUpgradeDowngrade];
            NSMutableArray *updatedPrevStartVersions = [NSMutableArray arrayWithArray:prevStartupVersions];
            [updatedPrevStartVersions addObject:currentVersion];
            [[NSUserDefaults standardUserDefaults] setObject:updatedPrevStartVersions forKey:@"prevStartupVersions"];
        }
    }
    
    // Save changes to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) firstStartAfterUpgradeDowngrade {
    NSLog(@"firstStartAfterUpgradeDowngrade");
}

-(void) firstStartAfterFreshInstall {
    NSLog(@"firstStartAfterFreshInstall");
}

-(IBAction)showPreferences:(id)sender{
    if(!preferencesController) {
        preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
    }
    [preferencesController showWindow:preferencesController];
    [[NSApp mainWindow] makeKeyAndOrderFront:preferencesController];
    
}

- (NSString *)windowNibName {
	return @"MenuController";
}

-(void) menuWillOpen:(NSMenu *) theMenu {
    // poll our app for nowPlaying info, but don't wait for a response
    // we'll get a message when apps have been polled and we can update
    // the menu item then
    [appWatcher checkNowPlaying];
    // set our inverse icon
    NSBundle *bundle = [NSBundle mainBundle];
    [self.statusBar setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"s150_inverse" ofType:@"png"]]];

}

-(void) menuDidClose:(NSMenu *) theMenu {
    // reset to our normal icon
    NSBundle *bundle = [NSBundle mainBundle];
    [self.statusBar setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"s150" ofType:@"png"]]];
}

-(IBAction) openMyTastyHomePage:(id)sender {
    [tasteLogger openTastePage];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self setStatusBar:[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]];
    
    // set the menu bar icon
    NSBundle *bundle = [NSBundle mainBundle];
    [self.statusBar setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"s150" ofType:@"png"]]];
    [self.statusBar setMenu:self.statusMenu];
    [self.statusBar.menu setDelegate:self];
    [self.statusBar setHighlightMode:YES];
    
    // register a listener for 'now playing' messages to update the
    // now playing menu item
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNowPlayingMessage:)
                                                 name:@"nowPlaying"
                                               object:nil];
}

- (void)handleNowPlayingMessage:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    Taste *nowPlaying = [userInfo objectForKey:@"nowPlaying"];
    [self setNowPlayingText:[nowPlaying nowPlayingStatusText]];
}

-(void)setNowPlayingText:(NSString *)text {
    NSMenuItem *nowPlayingMenuItem = [self.statusBar.menu itemWithTag:1010];
    if (text == nil) {
        [nowPlayingMenuItem setTitle:@"Not Playing"];
    } else {
        [nowPlayingMenuItem setTitle:text];
    }
}
@end
