//
//  BeaconScanner.m
//  BeaconScanner
//
//  Created by William Kuo on 2017/9/28.
//  Copyright © 2017年 William Kuo. All rights reserved.
//

#import "BeaconScanner.h"

@implementation BeaconScanner

@synthesize manager, knownBeacons, beaconRegions, foundBeacons;
@synthesize autoAskForAuthorized, scanTime, delegate;

- (void)dealloc {
    NSLog(@"beaconScanner Died");
}

// Scan Init Functions

- (id)initWithBeacons: (NSArray *)knownBeaconIDs andScanTime: (int)time isAutoAskForAuth: (BOOL) shouldAskForAuth {
    self = [super init];
    
    if (self) {
        knownBeacons = knownBeaconIDs;
        beaconRegions = [[NSMutableArray alloc] init];
        foundBeacons = [[NSMutableSet alloc] init];
        autoAskForAuthorized = shouldAskForAuth;
        scanTime = time;
        
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        
        if (autoAskForAuthorized) {
            [manager requestWhenInUseAuthorization];
        } else {
            [self checkHasBeaconScanAuthOrNot];
        }
        
        [self addBeaconsIntoRegions];
    }
    
    return self;
}

- (void)checkHasBeaconScanAuthOrNot {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse: break;
        case kCLAuthorizationStatusAuthorizedAlways: break;
        default:
            NSLog(@"[Beacon Scanner] Beacon Scan Authorized Not Allow");
            break;
    }
}

-(void)addBeaconsIntoRegions {
    
    for (NSString *beaconID in knownBeacons) {
        NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:beaconID];
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID: beaconUUID identifier: beaconID];
        [beaconRegions addObject: region];
    }
}


// Scan Run Functions

- (void)startScanRegion {
    for (CLBeaconRegion *region in beaconRegions) {
        [manager startRangingBeaconsInRegion: region];
    }
    [self performSelector: @selector(stopScanRegion) withObject: nil afterDelay: scanTime];
}

- (void)stopScanRegion {
    for (CLBeaconRegion *region in beaconRegions) {
        [manager startRangingBeaconsInRegion: region];
    }
    
    [delegate beaconScanWillFinish: self];
}

// Manager Delegate Function

- (void)locationManager: (CLLocationManager *)manager didRangeBeacons: (NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    for (CLBeacon *beacon in beacons) {
        BeaconInfo *beaconInfo = [self makeBeaconInfoWithCLBeacon: beacon];
        BOOL hasThisBeaconAlready = [self hasThisBeaconAlready: beaconInfo];
        
        if (hasThisBeaconAlready) {} else {
            [foundBeacons addObject: beaconInfo];
        }
    }
}

- (BeaconInfo *)makeBeaconInfoWithCLBeacon: (CLBeacon *)beacon {
    
    NSUUID *beaconUUID = beacon.proximityUUID;
    NSString *beaconID = [beaconUUID UUIDString];
    NSString *beaconMajor = [beacon.major stringValue];
    NSString *beaconMinor = [beacon.minor stringValue];
    
    BeaconInfo *beaconInfo = [[BeaconInfo alloc] initWithBeaconID:beaconID];
    beaconInfo.major = beaconMajor;
    beaconInfo.minor = beaconMinor;
    
    return beaconInfo;
}

- (BOOL)hasThisBeaconAlready: (BeaconInfo *) beacon {
    for (BeaconInfo *aBeacon in foundBeacons) {

        BOOL isEqualToBeaconID = [aBeacon.beaconID isEqualToString:beacon.beaconID];
        BOOL isEqualToMajor = [aBeacon.major isEqualToString:beacon.major];
        BOOL isEqualToMinor = [aBeacon.minor isEqualToString:beacon.minor];
        
        if (isEqualToBeaconID && isEqualToMajor && isEqualToMinor) {
            return YES;
        }
    }
    return NO;
}







@end
