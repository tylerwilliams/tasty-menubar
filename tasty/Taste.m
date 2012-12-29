//
//  Taste.m
//  tasty-menubar-cocoa
//
//  Created by Tyler Williams on 12/20/12.
//  Copyright (c) 2012 Tyler Williams. All rights reserved.
//

#import "Taste.h"

@implementation Taste

@synthesize source;
@synthesize artistName;
@synthesize songName;
@synthesize timestamp;
@synthesize releaseName;
@synthesize duration;
@synthesize rating;
@synthesize playCount;
@synthesize favorite;
@synthesize skip;

-(id)initWithFields:(NSString *)s
     withArtistName:(NSString *)an
       withSongName:(NSString *)sn
      withTimestamp:(NSNumber *)ts
    withReleaseName:(NSString *)rn
       withDuration:(NSNumber *)d
         withRating:(NSNumber *)r
      withPlayCount:(NSNumber *)pc
       withFavorite:(NSNumber *)f
           withSkip:(NSNumber *)b {
    if ( self = [super init] ) {
        source = s;
        artistName = an;
        songName = sn;
        timestamp = ts;
        releaseName = rn;
        duration = d;
        rating = r;
        playCount = pc;
        favorite = f;
        skip = b;
        return self;
    }
    return nil;
};

-(NSString *) nowPlayingStatusText {
    return [NSString stringWithFormat: @"%@ - %@", artistName, songName];
}

-(void) print {
    // The class can directly access the instance variables (versus calling message as above)
    NSLog(@"\n (%@) %@ - %@ @ %ld", source, artistName, songName, [timestamp integerValue]);
}

- (BOOL)isEqual: (id)other
{
    return ([other isKindOfClass: [Taste class]] &&
            [[other source] isEqualTo:source] &&
            [[other songName] isEqualTo:songName] &&
            [[other artistName] isEqualTo:artistName] &&
            [[other releaseName] isEqualTo:releaseName]);
}

-(NSUInteger)hash {
    NSUInteger result = 1;
    NSUInteger prime = 31;
    
    // Add any object that already has a hash function (NSString)
    result = prime * result + [self.source hash];
    result = prime * result + [self.artistName hash];
    result = prime * result + [self.songName hash];
    result = prime * result + [self.releaseName hash];
    
    return result;
}

-(NSString *)jsonRepresentation {
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];

    /* required fields */
    [jsonDictionary setValue:source forKey:@"source"];
    [jsonDictionary setValue:artistName forKey:@"artist_name"];
    [jsonDictionary setValue:songName forKey:@"song_name"];
    [jsonDictionary setValue:timestamp forKey:@"timestamp"];

    /* optional fields */
    if (nil != releaseName) {
        [jsonDictionary setValue:releaseName forKey:@"release_name"];
    }
    if (nil != duration) {
        [jsonDictionary setValue:duration forKey:@"duration"];
    }
    if (nil != rating) {
        [jsonDictionary setValue:rating forKey:@"rating"];
    }
    if (nil != playCount) {
        [jsonDictionary setValue:playCount forKey:@"play_count"];
    }
    if (favorite) {
        [jsonDictionary setValue:favorite forKey:@"favorite"];
    }
    if (skip) {
        [jsonDictionary setValue:skip forKey:@"skip"];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (id)copyWithZone:(NSZone *)zone {
    Taste *objectCopy = [[Taste allocWithZone:zone] init];
    objectCopy.source = source;
    objectCopy.artistName = artistName;
    objectCopy.songName = songName;
    objectCopy.timestamp = timestamp;
    objectCopy.releaseName = releaseName;
    objectCopy.duration = duration;
    objectCopy.rating = rating;
    objectCopy.playCount = playCount;
    objectCopy.favorite = favorite;
    objectCopy.skip = skip;
    // Copy over all instance variables from self to objectCopy.
    // Use deep copies for all strong pointers, shallow copies for weak.
    return objectCopy;
}
@end

