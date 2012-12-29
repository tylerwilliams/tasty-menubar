//
//  RdioWatcher.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/24/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "GenericWatcher.h"
#import "Rdio.h"

@interface RdioWatcher : GenericWatcher {
    NSString *appIdent;                 // "com.rdio.desktop"
}

-(id) init;
-(Taste*) poll;
@end