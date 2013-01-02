//
//  NetUtil.m
//  tasty
//
//  Created by Tyler Williams on 12/27/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "TasteRecorder.h"

@implementation TasteRecorder

- (id) initWithPrefsController:(PreferencesController *)p withLogger:(ASLLogger *)l {
    if ( self = [super init] ) {
        preferencesController = p;
        logger = l;
        // register a listener for 'now playing' messages to update the
        // now playing menu item
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTasteMessage:)
                                                     name:@"taste"
                                                   object:nil];
    }
    return self;
}

- (NSData *) encodeDictionary:(NSDictionary*)dictionary {
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
    NSURL *url = [ [ NSURL alloc ] initWithString:urlString];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)handleTasteMessage:(NSNotification *)notification {
    if (![[preferencesController getUserDefault:@"incognitoMode"] boolValue]) {
        NSDictionary *userInfo = notification.userInfo;
        Taste *toPush = [userInfo objectForKey:@"taste"];
        [self pushTaste:toPush];
    } else {
        [logger debug:@"Not logging taste because we're in incognitoMode!"];
    }
}

/*
  NSURLConnection things
*/

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [logger warn:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *jsonDecodeError;
    NSMutableDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&jsonDecodeError];
    // TODO: do something with this: either mark it played in our DB or retry
    [logger debug:[NSString stringWithFormat:@"server response:%@", jsonDictionary]];
}


- (void) pushTaste:(Taste *)t {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%li/api/%@/%@/tastes/new",
                           [preferencesController getUserDefault:@"apiHost"],
                           [[preferencesController getUserDefault:@"apiPort"] integerValue],
                           [preferencesController getUserDefault:@"apiVersion"],
                           [preferencesController macAddressString]
                           ];
    NSString *jsonString = [t jsonRepresentation];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSData *requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        receivedData = [NSMutableData new];
    } else {
        [logger warn:@"unable to make HTTP request"];
    }
}
@end
