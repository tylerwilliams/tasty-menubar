//
//  NSAttributedString+Hyperlink.h
//  tasty
//
//  Created by Tyler Williams on 1/19/13.
//  Copyright (c) 2013 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end