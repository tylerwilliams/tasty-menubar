//
//  SpotifyWatcher.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/24/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "GenericWatcher.h"
#import "Spotify.h"

@interface SpotifyWatcher : GenericWatcher {
    NSString *appIdent;                 // "com.spotify.client"
}

-(id) init;
-(Taste*) poll;
@end
