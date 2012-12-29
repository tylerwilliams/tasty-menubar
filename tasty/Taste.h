//
//  Taste.h
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/20/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Taste : NSObject {
    /* REQUIRED FIELDS */
    NSString *source;
    NSString *artistName;
    NSString *songName;
    NSNumber *timestamp;

    /* OPTIONAL FIELDS */
    NSString *releaseName;
    NSNumber *duration;
    NSNumber *rating;
    NSNumber *playCount;
    NSNumber *favorite;
    NSNumber *skip;
}

@property NSString *source;
@property NSString *artistName;
@property NSString *songName;
@property NSNumber *timestamp;
@property NSString *releaseName;
@property NSNumber *duration;
@property NSNumber *rating;
@property NSNumber *playCount;
@property NSNumber *favorite;
@property NSNumber *skip;

-(id)initWithFields:(NSString *)s
     withArtistName:(NSString *)an
       withSongName:(NSString *)sn
      withTimestamp:(NSNumber *)ts
    withReleaseName:(NSString *)rn
       withDuration:(NSNumber *)d
         withRating:(NSNumber *)r
      withPlayCount:(NSNumber *)pc
       withFavorite:(NSNumber *)f
           withSkip:(NSNumber *)b;

-(NSString *) nowPlayingStatusText ;
-(void) print;
-(id)copyWithZone:(NSZone *)zone;
-(NSString *) jsonRepresentation;
@end

