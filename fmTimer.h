//
//  fmTimer.h
//
//  Created by 柯浩然 on 7/24/18.
//

#import <Foundation/Foundation.h>

@interface fmTimer : NSObject
/// Initializes a timer using the specified object and selector. Upon firing, the timer sends the message aSelector to target
/// - partmeter:  date  The time at which the timer should first fire.
- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep runloopMode:(NSRunLoopMode)mode;

///After ti seconds have elapsed, the timer fires, invoking invocation.
/// - partmeter:  mode  Creates a new timer and schedules it on the mode.
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo runloopMode:(NSRunLoopMode)mode;

- (void)fire;
- (void)invalidate;
@end
