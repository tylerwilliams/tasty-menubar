//
//  tasteLogger.h
//  tasty
//
//  Created by Tyler Williams on 12/27/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferencesController.h"
#import "Taste.h"

@interface TasteLogger : NSObject {
    NSString *hostName;
    NSInteger portNumber;
    PreferencesController *preferencesController;
}

-(id) initWithPrefsController:(PreferencesController*)p;
- (void) openTastePage;
@end
