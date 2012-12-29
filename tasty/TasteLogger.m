//
//  NetUtil.m
//  tasty
//
//  Created by Tyler Williams on 12/27/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "TasteLogger.h"

@implementation TasteLogger

-(id) initWithPrefsController:(PreferencesController *)p {
    if ( self = [super init] ) {
        preferencesController = p;
        // register a listener for 'now playing' messages to update the
        // now playing menu item
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTasteMessage:)
                                                     name:@"taste"
                                                   object:nil];
    }
    return self;
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) openTastePage {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%li/api/%@/%@/tastes",
                           [preferencesController getUserDefault:@"apiHost"],
                           [[preferencesController getUserDefault:@"apiPort"] integerValue],
                           [preferencesController getUserDefault:@"apiVersion"],
                           [preferencesController macAddressString]
                           ];
    
    // generate url
    NSURL *url = [ [ NSURL alloc ] initWithString:urlString];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)handleTasteMessage:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    Taste *toPush = [userInfo objectForKey:@"taste"];
    [self pushTaste:toPush];
}

- (Boolean) pushTaste:(Taste *)t {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%li/api/%@/%@/new",
                           [preferencesController getUserDefault:@"apiHost"],
                           [[preferencesController getUserDefault:@"apiPort"] integerValue],
                           [preferencesController getUserDefault:@"apiVersion"],
                           [preferencesController macAddressString]
                           ];
    NSString *jsonString = [t jsonRepresentation];
    NSLog(@"urlString: %@", urlString);
    NSLog(@"jsonString: %@", jsonString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSData *requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
//        NSData *receivedData = [NSMutableData new];
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSDictionary *jsonDict = [jsonString JSONValue];
//        NSDictionary *question = [jsonDict objectForKey:@"question"];
    }
    return TRUE;
}
@end
