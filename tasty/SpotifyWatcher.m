//
//  SpotifyWatcher.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/24/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "SpotifyWatcher.h"

@implementation SpotifyWatcher

-(id) init {
    if ( self = [super init] ) {
        appIdent = @"com.spotify.client";
        return self;
    }
    return nil;
}

-(Taste *) poll {
    SpotifyApplication *app = [SBApplication applicationWithBundleIdentifier:appIdent];
    if (!app) {
        NSLog(@"app (%@) is null (not installed?)", appIdent);
        return nil;
    }
    if (![app isRunning]) {
        NSLog(@"app (%@) is not running", appIdent);
        return nil;
    }
    //    NSLog(@"polling %@", app);
    if (SpotifyEPlSPlaying != [app playerState]) {
        NSLog(@"app (%@) is paused", appIdent);
        return nil;
    }
    
    SpotifyTrack *ct = [app currentTrack];
    
    Taste *t = [[Taste alloc] initWithFields:@"Spotify.app"
                              withArtistName:[ct artist]
                                withSongName:[ct name]
                               withTimestamp:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
                             withReleaseName:[ct album]
                                withDuration:[NSNumber numberWithFloat:[ct duration]]
                                  withRating:nil
                               withPlayCount:[NSNumber numberWithInteger:[ct playedCount]]
                                withFavorite:[NSNumber numberWithBool:[ct starred]]
                                    withSkip:[NSNumber numberWithBool:FALSE]
                ];
    
    return t;
}
@end
