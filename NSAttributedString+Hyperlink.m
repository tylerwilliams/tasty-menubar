//
//  NSAttributedString+Hyperlink.m
//  tasty
//
//  Created by Tyler Williams on 1/19/13.
//  Copyright (c) 2013 Tyler Williams. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    
    // TBW: no fon't changing weirdness
    [attrString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Lucida Grande" size:13] range:range];
    
    [attrString endEditing];
    
    return attrString;
}

@end
