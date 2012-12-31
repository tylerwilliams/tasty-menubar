//
//  MoveProxy.m
//  tasty
//
//  Created by Tyler Williams on 12/31/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "MoveProxy.h"

@implementation MoveProxy

- (void) moveOrDie {
    PFMoveToApplicationsFolderIfNecessary();
}

@end
