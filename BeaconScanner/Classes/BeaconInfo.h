//
//  BeaconInfo.h
//  BeaconScanner
//
//  Created by William Kuo on 2017/9/28.
//  Copyright © 2017年 William Kuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconInfo : NSObject

@property(nonatomic) NSString *beaconID; // beaconID
@property(nonatomic) NSString *major;
@property(nonatomic) NSString *minor;

- (id)initWithBeaconID: (NSString *)beaconID;

@end
