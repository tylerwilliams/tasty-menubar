//
//  GenericWatcher.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/21/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taste.h"

@interface GenericWatcher : NSObject

-(Taste *) poll;

@end
