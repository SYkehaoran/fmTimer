//
//  fmTimer.m
//
//  Created by 柯浩然 on 7/24/18.
//

#import "fmTimer.h"

@interface fmProxy:NSProxy

+ (instancetype)weakProxyWithTarget:(id)target;

@end

@interface fmProxy()

@property(nonatomic, weak) id target;

@end

@implementation fmProxy

// This is the designated creation method of an `fmProxy` and
// as a subclass of `NSProxy` it doesn't respond to or need `-init`.
+ (instancetype)weakProxyWithTarget:(id)target {
    fmProxy *p = [fmProxy alloc];
    p.target = target;
    return p;
}

#pragma mark Forwarding Messages
- (id)forwardingTargetForSelector:(SEL)selector
{
    // Keep it lightweight: access the ivar directly
    return _target;
}

#pragma mark Handling Unimplemented Methods

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // Fallback for when target is nil. Don't do anything, just return 0/NULL/nil.
    // The method signature we've received to get here is just a dummy to keep `doesNotRecognizeSelector:` from firing.
    // We can't really handle struct return types here because we don't know the length.
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    // We only get here if `forwardingTargetForSelector:` returns nil.
    // In that case, our weak target has been reclaimed. Return a dummy method signature to keep `doesNotRecognizeSelector:` from firing.
    // We'll emulate the Obj-c messaging nil behavior by setting the return value to nil in `forwardInvocation:`, but we'll assume that the return value is `sizeof(void *)`
   
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
@end


@interface fmTimer()
{
    NSTimer *_timer;
}
@end

@implementation fmTimer

- (void)dealloc {
    
    [self invalidate];
}

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep runloopMode:(NSRunLoopMode)mode{

    self = [super init];
    if (self) {
        
        fmProxy *weakProxy = [fmProxy weakProxyWithTarget:t];
        _timer = [[NSTimer alloc] initWithFireDate:date interval:ti target:weakProxy selector:s userInfo:ui repeats:rep];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:mode];
    }
    return self;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo runloopMode:(NSRunLoopMode)mode {
    
    fmTimer *t = [[fmTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:target selector:aSelector userInfo:userInfo repeats:yesOrNo runloopMode:mode];
    return t;
}

- (void)fire {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)invalidate {
    [_timer invalidate];
    _timer = nil;
}

@end
