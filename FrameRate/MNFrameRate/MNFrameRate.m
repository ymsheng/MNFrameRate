//
//  MNFrameRate.m
//  FrameRate
//
//  Created by mosn on 11/17/15.
//  Copyright © 2015 com.*. All rights reserved.
//

#import "MNFrameRate.h"
#import <SpriteKit/SpriteKit.h>

#define kHardwareFramesPerSecond 60
static double const kNormalFrameDuration = 1.0 / kHardwareFramesPerSecond;

@interface MNFrameRate()
{
    double currentSecondRate[kHardwareFramesPerSecond];
    int frameCounter;
}

@property (nonatomic) BOOL running;

@property (strong,nonatomic) UILabel *rateLabel;

@property (nonatomic, strong) SKView *sceneView;

@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation MNFrameRate

+ (instancetype)sharedFrameRate
{
    static MNFrameRate *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MNFrameRate alloc] init];
    });
    
    return instance;
}
- (instancetype)init
{
    if (self=[super init]) {
    
        self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0,65, 20)];
        self.rateLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.rateLabel.backgroundColor = [UIColor grayColor];
        self.rateLabel.textColor = [UIColor whiteColor];
        self.rateLabel.textAlignment = NSTextAlignmentCenter;

        [[[UIApplication sharedApplication] keyWindow] addSubview:self.rateLabel];
        
    }
    return self;
}

- (void)dealloc
{
    [_displayLink invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark RunAble

- (void)setEnabled:(BOOL)enabled ///set is able run
{
    if (_enabled != enabled) {
        if (enabled) {
            [self enable];
        }
        else{
            [self disable];
        }
        _enabled = enabled;
    }
}


- (void)enable
{
    self.rateLabel.hidden = NO;
//    self.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        self.running = YES;
    }
}

- (void)disable
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.running = NO;
    self.rateLabel.hidden = YES;
//    self.hidden = YES;
}

#pragma mark -
- (void)setRunning:(BOOL)running
{
    if (_running != running) {
        if (running) {
            [self start];
        } else {
            [self stop];
        }
        
        _running = running;
    }
}

- (void)start
{
    frameCounter = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkWillDraw:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
    SKScene *scene = [SKScene new];
    self.sceneView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.sceneView presentScene:scene];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.sceneView];
}

- (void)stop
{
    [self.sceneView removeFromSuperview];
    self.sceneView = nil;
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark -
#pragma mark DrawLink
- (void)displayLinkWillDraw:(CADisplayLink *)link
{
    [self updateFrameTimer:link.timestamp];
    ///update
    int lostCount = [self lostFrameCountCurrentSecond];
    int drawCount = [self drawFrameCountCurrentSecond:lostCount];

    NSString *lostString = [NSString stringWithFormat:@"%d",lostCount];
    NSString *drwaString = [NSString stringWithFormat:@"%d",drawCount];
    if (lostCount<= 0) {
        lostString = @"--";
        self.rateLabel.backgroundColor = [UIColor greenColor];
    }
    else if(lostCount<=2){
        self.rateLabel.backgroundColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1];
    }
    else if(lostCount<12){
        self.rateLabel.backgroundColor = [UIColor orangeColor];
    }
    else{
        self.rateLabel.backgroundColor = [UIColor redColor];
    }
    if (drawCount==-1) {
        drwaString = @"--";
    }
    
    self.rateLabel.text = [NSString stringWithFormat:@"%@    %@",lostString,drwaString];
}

- (void)updateFrameTimer:(double)frameTime
{
    ++frameCounter;
    currentSecondRate[frameCounter%kHardwareFramesPerSecond] = frameTime;
}

- (int)lostFrameCountCurrentSecond
{
    int lostFrameCount = 0;
    double currentFrameTime = CACurrentMediaTime() - kNormalFrameDuration;
    for (int i=0; i<kHardwareFramesPerSecond; ++i) {
        if (1.0 <= currentFrameTime - currentSecondRate[i]) {
            ++lostFrameCount;
        }
    }
    return lostFrameCount;
}

- (int)drawFrameCountCurrentSecond:(int)lostCount
{
    if (!self.running || frameCounter<kHardwareFramesPerSecond) {
        return -1;
    }
    return kHardwareFramesPerSecond-lostCount;
}

#pragma mark -
#pragma mark Notify
- (void)applicationDidBecomeActive
{
    self.running = self.enabled;
}

- (void)applicationWillResignActive
{
    self.running = NO;
}




@end
