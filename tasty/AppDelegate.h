//
//  AppDelegate.h
//  tasty
//
//  Created by Tyler Williams on 12/26/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MenuController;
@class PreferencesController;
@class AppWatcher;
@class TasteRecorder;
@class ASLLogger;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	MenuController				*menuController;
	PreferencesController       *preferencesController;
    AppWatcher                  *appWatcher;
    TasteRecorder               *tasteRecorder;
    ASLLogger                   *logger;
}

@property (strong) MenuController *menuController;
@property (strong) PreferencesController *preferencesController;
@property (strong) AppWatcher *appWatcher;
@property (strong) TasteRecorder *tasteRecorder;

@end

