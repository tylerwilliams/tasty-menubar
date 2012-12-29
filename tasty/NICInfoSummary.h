//
//  NICInfoSummary.h
//  NICInfo
//
//  Class for getting network interfaces address information instantly.
//  For usage, Refer to https://bitbucket.org/kenial/nicinfo/wiki
//
//
//  AUTHOR          : kenial (keniallee@gmail.com)
//

#import <Foundation/Foundation.h>
#import "NICInfo.h"

@interface NICInfoSummary : NSObject {
    NSArray*    nicInfos;
}

@property (readonly) NSArray* nicInfos;

+ (NICInfoSummary *)infoSummary;
+ (NICInfoSummary *)refreshInfoSummary;

// Let me have all NIC information on this device!
- (NICInfo *)findNICInfo:(NSString*)interface_name;

// iPhone's NIC :
//  pdp_ip0 : 3G
//  en0 : wifi
//  en2 : bluetooth
//  bridge0 : personal hotspot

// macbook air's NIC (it varies on devices) :
//  en0 : wifi
//  en1 : iphone USB
//  en2 : bluetooth


- (bool)isWifiConnected;
- (bool)isWifiConnectedToNAT;
- (bool)isBluetoothConnected;
- (bool)isPersonalHotspotActivated;
- (bool)is3GConnected;

- (NSArray *)broadcastIPs;


// CAUTION : valid for only IP v4
// return any NicInfo that IP address is assigned
- (NICInfo *)anyAvailableNicInfo;
// return NICs assigned IPv4 IP address
- (NSArray *)availableNicInfos;
// return IP info that vaild IP v4 address is assigned
- (NSArray *)availableIPInfov4;

@end
