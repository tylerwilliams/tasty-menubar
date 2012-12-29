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
    }
    return self;
}

-(IBAction)showPreferences:(id)sender{
    if(!preferencesController) {
        preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
    }
    [preferencesController showWindow:self];
}

- (NSString *)windowNibName {
	return @"MenuController";
}

-(void) menuWillOpen:(NSMenu *) theMenu {
    // poll our app for nowPlaying info, but don't wait for a response
    // we'll get a message when apps have been polled and we can update
    // the menu item then
    [appWatcher checkNowPlaying];
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
    [self.statusBar setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"en_menu" ofType:@"png"]]];
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
