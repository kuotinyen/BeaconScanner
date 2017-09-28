//
//  BeaconInfo.m
//  BeaconScanner
//
//  Created by William Kuo on 2017/9/28.
//  Copyright © 2017年 William Kuo. All rights reserved.
//

#import "BeaconInfo.h"

@implementation BeaconInfo

- (id)initWithBeaconID: (NSString *)beaconID {
    self = [super init];
    
    if (self) {
        self.beaconID = beaconID;
    }
    
    return self;
}

@end
