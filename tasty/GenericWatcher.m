//
//  GenericWatcher.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/21/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "GenericWatcher.h"

@implementation GenericWatcher

-(Taste *) poll {
    @throw [NSException exceptionWithName:@"NotImplementedError" reason:@"Override this!" userInfo:nil];
};

@end
