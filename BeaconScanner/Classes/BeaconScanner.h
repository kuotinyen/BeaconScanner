//
//  BeaconScanner.h
//  BeaconScanner
//
//  Created by William Kuo on 2017/9/28.
//  Copyright © 2017年 William Kuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BeaconInfo.h"

@protocol BeaconScannerDelegate;

// Main
@interface BeaconScanner : NSObject <CLLocationManagerDelegate>

@property(nonatomic) CLLocationManager *manager;

@property(nonatomic) NSArray *knownBeacons;
@property(nonatomic) NSMutableArray *beaconRegions;
@property(nonatomic) NSMutableSet *foundBeacons;

@property(nonatomic, assign) int scanTime;
@property(nonatomic, assign) BOOL autoAskForAuthorized;

@property __weak id <BeaconScannerDelegate> delegate;

- (id)initWithBeacons: (NSArray *)knownBeaconIDs andScanTime: (int)scanTime isAutoAskForAuth: (BOOL) shouldAskForAuth;
- (void)startScanRegion;
- (void)stopScanRegion;

@end

// Delegate
@protocol BeaconScannerDelegate <NSObject>
@optional
- (void)beaconScanWillFinish: (BeaconScanner *)beaconScanner;
@end
