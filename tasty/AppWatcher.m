//
//  AppWatcher.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/20/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "AppWatcher.h"

#define PLAYED_THRESHOLD_PERCENTAGE .80
#define PLAYED_THRESHOLD_SECONDS 3*60
#define SKIPPED_THRESHOLD_SECONDS 3

@implementation AppWatcher

@synthesize nowPlaying;
@synthesize nowTasting;

-(id) initWithPrefsController:(PreferencesController *)p {
    if ( self = [super init] ) {
        prefController = p;
        pollInterval = [p pollInterval];
        pollTimer = [NSTimer scheduledTimerWithTimeInterval:pollInterval
                                                     target:self
                                                     selector:@selector(handleTimerCallback:)
                                                     userInfo:nil
                                                     repeats:YES];
        /* 
         add the timer to different runloop modes. this allows it to run while
         the user is viewing the menu, editing preferences, etc.
         */
        [[NSRunLoop mainRunLoop] addTimer:pollTimer forMode:NSRunLoopCommonModes];
        activeWatchers = [NSMutableDictionary new];
        activeTastes = [NSMutableDictionary new];
        
        // register preference observers so that watchers are correctly enabled and disabled
        // as preferences change, and ping our appWatcher to enable or disable the correct
        // watchers
        NSArray *watcherKeys = [NSArray arrayWithObjects:  @"watchItunes", @"watchSpotify", @"watchRdio", nil];
        for (NSString *watcherKey in watcherKeys) {
            [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                                                      forKeyPath:[@"values." stringByAppendingString: watcherKey]
                                                                         options:NSKeyValueObservingOptionNew
                                                                         context:NULL];
            [self enableOrDisableWatcherForPrefKey:watcherKey];
        }        
        return self;
    }
    return nil;
}

-(void)enableWatcher:(NSString *)watcherClassName {
    /* 
     given an NSString like "iTunesWatcher" enable
     that watcher for tastes + now playing info
     */
    NSObject *existing = [activeWatchers objectForKey:watcherClassName];
    if (existing == nil) {
        id watcher = [[NSClassFromString(watcherClassName) alloc] init];
        if (watcher != nil) {
            [activeWatchers setObject:watcher forKey:watcherClassName];
        } else {
            NSLog(@"watcherClass for %@ NOT FOUND!", watcherClassName);
        }
    }
    NSLog(@"enabled %@", watcherClassName);
}

-(void)disableWatcher:(NSString *)watcherClassName {
    /*
     given an NSString like "spotifyWatcher" disable
     that watcher for tastes + now playing info
     */
    [activeWatchers removeObjectForKey:watcherClassName];
    NSLog(@"disabled %@", watcherClassName);
}

-(void)enableOrDisableWatcherForPrefKey:(NSString *)prefKey {
    Boolean enabled = (Boolean)[[NSUserDefaults standardUserDefaults] objectForKey:prefKey];
    NSString *watcherClassName;
    if ([prefKey isEqualToString:@"watchItunes"]) {
        watcherClassName = @"iTunesWatcher";
    } else if ([prefKey isEqualToString:@"watchSpotify"]) {
        watcherClassName = @"SpotifyWatcher";
    } else if ([prefKey isEqualToString:@"watchRdio"]) {
        watcherClassName = @"RdioWatcher";
    }
    
    if (enabled) {
        [self enableWatcher:watcherClassName];
    } else {
        [self disableWatcher:watcherClassName];
    }
}

-(void)checkNowPlaying {
    /*
     loop through our application watchers and fire each
     collate results and set Taste *nowPlaying; and Taste *nowTasting;
     note that if multiple sources are 'active' (open+playing), we will only deal with
     the last seen taste. Not trying to untangle that mess :)
     */
    Taste *np;
    for (NSString* key in activeWatchers) {
        GenericWatcher *watcher = [activeWatchers objectForKey:key];
        Taste *watcherTaste = [watcher poll];
        if (watcherTaste != nil) {
            np = watcherTaste;
        }
    }
    // update our nowPlaying instance
    nowPlaying = np;
    // send a message to anyone listening that the now playing instance has changed
    NSDictionary *userInfo;
    if (nowPlaying != nil) {
        userInfo = [NSDictionary dictionaryWithObject:nowPlaying forKey:@"nowPlaying"];
    } else {
        userInfo = [NSDictionary new];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nowPlaying" object:self userInfo:userInfo];
}

-(void)tasteSong:(Taste *)taste {
    NSDictionary *userInfo;
    if (taste != nil) {
        userInfo = [NSDictionary dictionaryWithObject:taste forKey:@"taste"];
    } else {
        userInfo = [NSDictionary new];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taste" object:self userInfo:userInfo];
}

-(void)handleTimerCallback:(NSTimer*)theTimer {
    [self checkNowPlaying]; // poll our nowPlaying var

    if (nowPlaying == nil) {
        return;
    }
    
    /*
     increase a playedCounter for each track in a map while it's still playing
     flush these when the playing track changes, and inspect their values to decide 
     if they were played or not
     
     Algorithm:
     - if the playing track is NOT in the active map
        - for each track in the map:
            - if the track in the map has a playedPercentage > played_threshold
                - scrobble it
            - else
                - if playedPercentage > skip_threshold
                    - scrobble skip
                - else:
                    - ignore (was quickly skipped)
            - remove from map     
     - else (the playing track IS in the active map)
        - increase the playedPercentage by (pollPeriod / duration)
        - if the playedPercentage > 1:
            - scrobble it
            - decrement the playedPercentage by 100%
     */
    
    NSNumber *period = [[NSNumber alloc] initWithDouble:pollInterval];
    if (nil == [activeTastes objectForKey:nowPlaying]) {
        for (Taste* activeTaste in activeTastes.allKeys) {
            double playedSeconds = [[activeTastes objectForKey:activeTaste] doubleValue];
            NSLog(@"activeTaste: %@, playedSeconds: %f", activeTaste, playedSeconds);
            double playedPercentage = (playedSeconds / [[activeTaste duration] floatValue]);
            NSLog(@"playedPercentage: %f (%f / %f)", playedPercentage, playedSeconds, [[activeTaste duration] floatValue]);
            [activeTaste print];
            if (playedPercentage > PLAYED_THRESHOLD_PERCENTAGE || playedSeconds > PLAYED_THRESHOLD_SECONDS) {
                [self tasteSong:activeTaste];
                NSLog(@"scrobble: %@", activeTaste);
            } else {
                if (playedSeconds > SKIPPED_THRESHOLD_SECONDS) {
                    [activeTaste setSkip:[NSNumber numberWithBool:TRUE]];
                    [self tasteSong:activeTaste];
                    NSLog(@"scrobble (_SKIP_): %@", activeTaste);
                } else {
                    NSLog(@"ignoring (skipped too fast): %@", activeTaste);
                }
            }
            [activeTastes removeObjectForKey:activeTaste];
        }        
        [activeTastes setObject:period forKey:(id <NSCopying>)nowPlaying];
    }
    else {
        double playedSeconds = [[activeTastes objectForKey:nowPlaying] doubleValue];
        NSLog(@"activeTaste: %@, playedSeconds: %f", nowPlaying, playedSeconds);
        if (playedSeconds > [[nowPlaying duration] floatValue]) {
            NSLog(@"scrobble (repeat!): %@", nowPlaying);
            [self tasteSong:nowPlaying];
            playedSeconds -= [[nowPlaying duration] floatValue];
        }
        playedSeconds += [period doubleValue];
        NSNumber *playedTime = [[NSNumber alloc] initWithDouble:playedSeconds];
        [activeTastes setObject:playedTime forKey:(id <NSCopying>)nowPlaying];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    /* handle enabling and disabling our listeners as the preferences are toggled */
    NSString *prefKey = [keyPath stringByReplacingOccurrencesOfString:@"values." withString:@""];
    [self enableOrDisableWatcherForPrefKey:prefKey];
}
@end

