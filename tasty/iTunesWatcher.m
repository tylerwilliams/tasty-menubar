//
//  iTunesWatcher.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/20/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "iTunesWatcher.h"

@implementation iTunesWatcher

-(id) init {
    if ( self = [super init] ) {
        appIdent = @"com.apple.itunes";
        return self;
    }
    return nil;
}

-(Taste *) poll {
    iTunesApplication *app = [SBApplication applicationWithBundleIdentifier:appIdent];
    if (!app) {
//        NSLog(@"app (%@) is null (not installed?)", appIdent);
        return nil;
    }
    if (![app isRunning]) {
//        NSLog(@"app (%@) is not running", appIdent);
        return nil;
    }
//    NSLog(@"polling %@", app);    
    if (iTunesEPlSPlaying != [app playerState]) {
//        NSLog(@"app (%@) is paused", appIdent);
        return nil;
    }

    iTunesTrack *ct = [app currentTrack];
    
    Taste *t = [[Taste alloc] initWithFields:@"iTunes.app"
                              withArtistName:[ct artist]
                                withSongName:[ct name]
                               withTimestamp:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
                             withReleaseName:[ct album]
                                withDuration:[NSNumber numberWithFloat:[ct duration]]
                                  withRating:[NSNumber numberWithInteger:[ct rating]]
                               withPlayCount:[NSNumber numberWithInteger:[ct playedCount]]
                                withFavorite:[NSNumber numberWithBool:FALSE]
                                    withSkip:[NSNumber numberWithBool:FALSE]
                ];

    return t;
}
@end
