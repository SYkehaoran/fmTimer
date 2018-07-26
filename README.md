# fmTimer
NSTimer drop-in alternative that doesn't retain the target 

This class was to have a type of timer that objects could own and retain, without this creating a retain cycle ( like NSTimer causes, since it retains its target ). This way you can just release the timer in the -dealloc method of the object class that owns the timer.
