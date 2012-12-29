//
//  iTunesWatcher.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/20/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "GenericWatcher.h"
#import "iTunes.h"

@interface iTunesWatcher : GenericWatcher {
    NSString *appIdent;                 // "com.apple.itunes"
}

-(id) init;
-(Taste*) poll;
@end
