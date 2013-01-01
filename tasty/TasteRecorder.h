//
//  tasteRecorder.h
//  tasty
//
//  Created by Tyler Williams on 12/27/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferencesController.h"
#import "Taste.h"
#import "ASLLogger.h"

@interface TasteRecorder : NSObject {
    NSString *hostName;
    NSInteger portNumber;
    PreferencesController *preferencesController;
    NSMutableData *receivedData;
    NSNumber *isLogging;            // this is really a BOOL :/
    ASLLogger *logger;
}

- (id) initWithPrefsController:(PreferencesController *)p withLogger:(ASLLogger *)l;
- (NSData *) encodeDictionary:(NSDictionary*)dictionary;
- (void) openTastePage;
- (void) handleTasteMessage:(NSNotification *)notification;
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;
- (void) pushTaste:(Taste *)t;

@end
