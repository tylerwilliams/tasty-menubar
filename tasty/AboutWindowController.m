//
//  AboutWindowController.m
//  tasty
//
//  Created by Tyler Williams on 1/18/13.
//  Copyright (c) 2013 Tyler Williams. All rights reserved.
//

#import "AboutWindowController.h"

@interface AboutWindowController ()

@end


@implementation AboutWindowController

@synthesize versionTextField;
@synthesize aboutScrollView;
@synthesize linkTextField;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    /* put in version */
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *shortVersion = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [[bundle infoDictionary] objectForKey:@"CFBundleVersion"];
    [versionTextField setStringValue:[NSString stringWithFormat:@"Version %@ (%@)", shortVersion, version]];

    /* put in readme from RTF */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AboutText" ofType:@"rtfd"];
    [[aboutScrollView documentView] readRTFDFromFile:path];
    [[aboutScrollView documentView] setEditable:FALSE];
    
    /* link up source url */
    [linkTextField setAllowsEditingTextAttributes: YES];
    [linkTextField setSelectable: YES];
    [linkTextField setFont:[linkTextField font]];
    NSURL* url = [NSURL URLWithString:@"https://github.com/tylerwilliams/tasty-menubar"];
    NSMutableAttributedString *string = [NSAttributedString hyperlinkFromString:@"github.com/tylerwilliams/tasty-menubar" withURL:url];
    
    // set the attributed string to the NSTextField
    [linkTextField setAttributedStringValue: string];
}

@end
