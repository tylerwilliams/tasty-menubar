//
//  MenuController.h
//  tasty
//
//  Created by Tyler Williams on 12/26/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"
#import "AppWatcher.h"
#import "TasteRecorder.h"
#import "LogUtils.h"
#import "AboutWindowController.h"

@interface MenuController : NSWindowController <NSMenuDelegate> {
	NSMenu *statusMenu;
    NSStatusItem *statusBar;
    PreferencesController *preferencesController;
    AboutWindowController *aboutController;
    AppWatcher *appWatcher;
    TasteRecorder *tasteRecorder;
    IBOutlet NSMenuItem *statusItem;
}

@property (strong, nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong, nonatomic) PreferencesController *preferencesController;
@property (strong, nonatomic) PreferencesController *aboutController;
@property (strong, nonatomic) AppWatcher *appWatcher;
@property (strong, nonatomic) TasteRecorder *tasteRecorder;

@property (assign) IBOutlet NSMenuItem *statusItem;

- (IBAction) showPreferences:(id)sender;
- (IBAction) showAbout:(id)sender;
- (IBAction) openMyTastyHomePage:(id)sender;
- (NSString *) windowNibName;
- (void) windowDidLoad;
- (id) initWithPrefsWatcher:(PreferencesController *)p withAppController:(AppWatcher *)a withtasteRecorder:(TasteRecorder *)n;
@end