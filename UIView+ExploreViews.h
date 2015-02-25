//
//  UIView+ExploreViews.h
//  EnflightMobile
//
//  Created by Phillip G. Apley on 11/27/12.
//
//

#import <UIKit/UIKit.h>

/*
 @protocol GestureReportProtocol <NSObject>
- (void)printGesture: (UIGestureRecognizer*)gesture
         WithMessage: (NSString*)message;
@end


@interface GestureReport : NSObject
{

}

@property (nonatomic, weak) id<GestureReportProtocol> gestureTarget;
@property (nonatomic, strong) NSString* message;
- (void)gestureReport: (UIGestureRecognizer*)gesture;
@end
*/

@interface UIView (ExploreViews)

- (void)exploreViewAtLevel:(int)level;
- (void)observeAllGesturesInSubviews;

@end

