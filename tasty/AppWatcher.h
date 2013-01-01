//
//  AppWatcher.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/20/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferencesController.h"
#import "GenericWatcher.h"
#import "Taste.h"
#import "ASLLogger.h"

@interface AppWatcher : NSObject {
    double pollInterval;                    // 2
    NSTimer *pollTimer;                     // NSTimer(2)
    NSMutableDictionary *activeWatchers;    // {'com.apple.itunes'=>iTunesWatcher(), 'com.spotify.client'=>SpotifyWatcher()}
    NSMutableDictionary *activeTastes;      // the tracks we're currently tracking
    PreferencesController *prefController;
    ASLLogger *logger;
    
    Taste *nowPlaying;                      // what we're currently listening too
    Taste *nowTasting;                      // what we just tasted
}

@property (readonly) Taste *nowPlaying;
@property (readonly) Taste *nowTasting;

- (id) initWithPrefsController:(PreferencesController *)p withLogger:(ASLLogger *)l;
-(void)enableWatcher:(NSString *)watcherClassName;
-(void)disableWatcher:(NSString *)watcherClassName;
-(void)enableOrDisableWatcherForPrefKey:(NSString *)prefKey;
-(void)handleTimerCallback:(NSTimer*)theTimer;
-(void)checkNowPlaying;
-(void)tasteSong:(Taste *)taste;
-(Taste *) nowPlaying;
-(Taste *) nowTasting;

@end
