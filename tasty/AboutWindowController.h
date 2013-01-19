//
//  AboutWindowController.h
//  tasty
//
//  Created by Tyler Williams on 1/18/13.
//  Copyright (c) 2013 Tyler Williams. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSAttributedString+Hyperlink.h"

@interface AboutWindowController : NSWindowController {

}

@property (strong) IBOutlet NSTextField *versionTextField;
@property (strong) IBOutlet NSScrollView *aboutScrollView;
@property (strong) IBOutlet NSTextField *linkTextField;

@end
