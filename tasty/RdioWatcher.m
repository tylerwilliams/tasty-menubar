//
//  RdioWatcher.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/24/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "RdioWatcher.h"

@implementation RdioWatcher

-(id) init {
    if ( self = [super init] ) {
        appIdent = @"com.rdio.desktop";
        return self;
    }
    return nil;
}

-(Taste *) poll {
    RdioApplication *app = [SBApplication applicationWithBundleIdentifier:appIdent];
    if (!app) {
        NSLog(@"app (%@) is null (not installed?)", appIdent);
        return nil;
    }
    if (![app isRunning]) {
        NSLog(@"app (%@) is not running", appIdent);
        return nil;
    }
    //    NSLog(@"polling %@", app);
    if (RdioEPSSPlaying != [app playerState]) {
        NSLog(@"app (%@) is paused", appIdent);
        return nil;
    }
    
    RdioTrack *ct = [app currentTrack];
        
    Taste *t = [[Taste alloc] initWithFields:@"Rdio.app"
                              withArtistName:[ct artist]
                                withSongName:[ct name]
                               withTimestamp:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
                             withReleaseName:[ct album]
                                withDuration:[NSNumber numberWithFloat:[ct duration]]
                                  withRating:nil
                               withPlayCount:nil
                                withFavorite:[NSNumber numberWithBool:FALSE]
                                    withSkip:[NSNumber numberWithBool:FALSE]
                ];
    
    return t;
}
@end
