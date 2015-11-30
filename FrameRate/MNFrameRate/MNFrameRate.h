//
//  MNFrameRate.h
//  FrameRate
//
//  Created by mosn on 11/17/15.
//  Copyright © 2015 com.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MNFrameRate : NSObject

///[MNFrameRate sharedFrameRate].enabled = YES -application:didFinishLaunchingWithOptions:
@property (nonatomic,assign,getter=isEnabled) BOOL enabled;


+ (instancetype)sharedFrameRate;

@end
