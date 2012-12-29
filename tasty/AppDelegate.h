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
@class TasteLogger;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	MenuController				*menuController;
	PreferencesController       *preferencesController;
    AppWatcher                  *appWatcher;
    TasteLogger                     *tasteLogger;
}

@property (strong) MenuController *menuController;
@property (strong) PreferencesController *preferencesController;
@property (strong) AppWatcher *appWatcher;
@property (strong) TasteLogger *tasteLogger;

@end

