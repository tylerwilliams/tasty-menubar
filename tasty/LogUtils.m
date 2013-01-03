//
//  LogUtils.m
//  tasty
//
//  Created by Tyler Williams on 1/3/13.
//  Copyright (c) 2013 Tyler Williams. All rights reserved.
//

#import "LogUtils.h"

@implementation LogUtils

+ (NSString *) logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
		return [[[paths objectAtIndex:0]
                 stringByAppendingPathComponent:@"Logs"]
                stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
	}
	
	NSAssert(NO, @"Could not find ~/Library/Logs directory.");
	return nil;
}

+ (void) mkdirP: (NSString *) filePathAndDirectory {
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePathAndDirectory]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

+ (NSFileHandle *) getFileHandle: (NSString *) filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(handle == nil) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    } else {
        [handle seekToEndOfFile];
    }
    return handle;
}

+ (ASLLogger *) tastyLogger {
    // make our logging directory if it doesn't yet exist
    NSString *logDir = [self logDirectory];
    [self mkdirP:logDir];
    
    ASLLogger *logger;
    NSMutableDictionary *thd;
    NSString *thdKey;
    NSString *ident = @"";
    thdKey = [@"ASLLogger_" stringByAppendingString:ident];
    thd = [[NSThread currentThread] threadDictionary];
    if ( !(logger = [thd objectForKey:thdKey]) ) {
        logger = [[ASLLogger alloc] initWithModule:ident];
        [thd setObject:logger forKey:thdKey];
    }
    /* 
     TBW: this is mega-stupid; why do I have to do it to log to my file correctly?
     I guess I'm mega-stupid for not knowing why. but it works, so piss off.
     */
    // log to ~/Library/logs/Tasty/tasty.log
    [logger addFileHandle:[self getFileHandle:[logDir stringByAppendingPathComponent:@"tasty.log"]]];
    // log to stderr
    [logger addFileHandle:[NSFileHandle fileHandleWithStandardError]];
    // debug level
    logger.connection.level = ASLLoggerLevelDebug;
    return logger;
}
@end
