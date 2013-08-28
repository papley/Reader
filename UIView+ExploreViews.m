//
//  UIView+ExploreViews.m
//  S6E11
//
//  Created by Phillip G. Apley on 11/27/12.
//
//

#import "UIView+ExploreViews.h"

// For gesture printing
//#import "MainViewController.h"

//static NSMutableArray* _gestureTargets;

void doLog(int level, id formatstring,...);

void doLog(int level, id formatstring,...)
{
    int i;
    for (i = 0; i < level; i++) printf("    ");

    va_list arglist;
    if (formatstring)
    {
        va_start(arglist, formatstring);
        id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
    }
}

/*
@implementation GestureReport : NSObject
@synthesize message;
@synthesize gestureTarget;

- (void)gestureReport: (UIGestureRecognizer*)gesture
{
    [gestureTarget printGesture: gesture
                    WithMessage: message];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        gestureTarget = [MainViewController sharedInstance];
        message = @"";
    }
    return self;
}
@end
*/

@implementation UIView (ExploreViews)

// TODO: (PGA): Debugging tool
- (void)observeAllGesturesInSubviews;
{
    if ([self respondsToSelector:@selector(gestureRecognizers)])
    {
        for (UIGestureRecognizer *gesture in self.gestureRecognizers)
        {
            // Turn on for gesture printing
            //           [gesture addTarget: [MainViewController sharedInstance]
            //                       action: @selector(printGesture:)];
        }
    }
    for (UIView *subview in [self subviews])
        [subview observeAllGesturesInSubviews];
}

- (void)exploreViewAtLevel:(int)level
{
    doLog(level++, @"--- View Class: *** %@ ***", [[self class] description]);
    if ([self respondsToSelector:@selector(delegate)])
        doLog(level, @"Has Delegate: %@", [[(id)self delegate] description]);
    //    if ([self respondsToSelector:@selector(pagingViewName)])
    //        doLog(level, @"PagingViewName: %@", [(id)self pagingViewName]);
    doLog(level, @"opaque? %d hidden %d color %x, alpha %f", self.opaque, self.hidden, self.backgroundColor, self.alpha);
    doLog(level, @"Frame: %@, Bounds: %@",
          NSStringFromCGRect([self frame]),
          NSStringFromCGRect([self bounds]));
    if ([self respondsToSelector:@selector(gestureRecognizers)])
    {
        doLog(level++, @"--- Gesture Recognizers:");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers)
        {
            doLog(level++, @"- Recognizer Class: *** %@ ***", [[gesture class] description]);
            if ([gesture isKindOfClass: UIPanGestureRecognizer.class] == YES)
            {
                doLog(level, @"A kind of UIPanGestureRecognizer");
                if ([gesture respondsToSelector:@selector(minimumNumberOfTouches)]) {
                    NSUInteger minT = [(UIPanGestureRecognizer*)gesture minimumNumberOfTouches];
                    doLog(level, @"Minimum number of touches: %u", minT);
                }
                if ([gesture respondsToSelector:@selector(maximumNumberOfTouches)]) {
                    //[(UIPanGestureRecognizer*)gesture setMaximumNumberOfTouches: 2];
                    NSUInteger maxT = [(UIPanGestureRecognizer*)gesture maximumNumberOfTouches];
                    doLog(level, @"Maximum number of touches: %u", maxT);
                }
            }
            else if ([gesture isKindOfClass: UISwipeGestureRecognizer.class] == YES)
            {
                doLog(level, @"A kind of UISwipeGestureRecognizer");
                if ([gesture respondsToSelector:@selector(numberOfTouchesRequired)])
                {
                    NSUInteger nTouch = [(UISwipeGestureRecognizer*)gesture numberOfTouchesRequired];
                    doLog(level, @"numberOfTouchesRequired (swipe or pan): %d",nTouch);
                }
            }
            else
            {
                if ([gesture respondsToSelector:@selector(minimumNumberOfTouches)]) {
                    NSUInteger minT = [(UIPanGestureRecognizer*)gesture minimumNumberOfTouches];
                    doLog(level, @"Minimum number of touches: %u", minT);
                }
                if ([gesture respondsToSelector:@selector(maximumNumberOfTouches)]) {
                    NSUInteger maxT = [(UIPanGestureRecognizer*)gesture maximumNumberOfTouches];
                    doLog(level, @"Maximum number of touches: %u", maxT);
                }
                if ([gesture respondsToSelector:@selector(numberOfTapsRequired)]) {
                    NSUInteger ntaps = [(UITapGestureRecognizer*)gesture numberOfTapsRequired];
                    doLog(level, @"Number of taps required: %d", ntaps);
                }
                if ([gesture respondsToSelector:@selector(numberOfTouchesRequired)])
                {
                    NSUInteger nTouch = [(UITapGestureRecognizer*)gesture numberOfTouchesRequired];
                    doLog(level, @"numberOfTouchesRequired (swipe or pan): %d",nTouch);
                }
            }
            NSString* gDesc = gesture.description;
            NSArray *gDescStrs = [gDesc componentsSeparatedByString:@";"];
            int strCnt = 0;
            for (NSString* str in gDescStrs)
            {
                if (strCnt == 0)
                    doLog(level + 1, str);
                else
                    doLog(level + 2, str);
                strCnt++;
            }
            //doLog(level, @"target: %@", [gesture target]);
            //target, state, view,

            if ([gesture respondsToSelector:@selector(locationInView:)]) {
                CGPoint gloc = [gesture locationInView:self];
                doLog(level, @"Gesture location in view: %f, %f",
                      gloc.x, gloc.y);
            }

            if ([gesture respondsToSelector:@selector(delaysTouchesBegan)])
            {
                bool dBool = [(UIGestureRecognizer*)gesture delaysTouchesBegan];
                doLog(level, @"delaysTouchesBegan: %@",dBool ? @"YES" : @"NO");
            }
            if ([gesture respondsToSelector:@selector(delaysTouchesEnded)])
            {
                bool dBool = [(UIGestureRecognizer*)gesture delaysTouchesEnded];
                doLog(level, @"delaysTouchesEnded: %@",dBool  ? @"YES" : @"NO");
            }
            if ([gesture respondsToSelector:@selector(cancelsTouchesInView)])
            {
                bool dBool = [(UIGestureRecognizer*)gesture cancelsTouchesInView];
                doLog(level, @"cancelsTouchesInView: %@",dBool ? @"YES" : @"NO");
            }
            if ([gesture respondsToSelector:@selector(direction)]) {
                enum UISwipeGestureRecognizerDirection dir =
                [(UISwipeGestureRecognizer*)gesture direction];
                doLog(level, @"direction(s): %@, %@, %@, %@",
                      (dir & UISwipeGestureRecognizerDirectionRight) ? @"Right" : @"-",
                      (dir & UISwipeGestureRecognizerDirectionLeft) ?  @"Left" : @"-",
                      (dir & UISwipeGestureRecognizerDirectionUp)   ?  @"Up" :  @"-",
                      (dir & UISwipeGestureRecognizerDirectionDown) ?  @"Down" : @"-");
            }
            
            //            [gesture addTarget: [UIApplication sharedApplication] action: @selector(printGesture:)];
            doLog(level--, @"- END Recognizer: %@", [[gesture class] description]);
        }
        doLog(level--, @"--- END Gesture Recognizers:");


    }
    doLog(level, @"---SUBVIEWS");
    for (UIView *subview in [self subviews])
        [subview exploreViewAtLevel:(level + 1)];
    doLog(level, @"||| END View: %@", [[self class] description]);
    level--;
}

@end