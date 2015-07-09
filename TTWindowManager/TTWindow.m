//
//  TTWindow.m
//  ThatKit
//
//  Created by Tyson Leslie on 2014-03-04.
//  Copyright (c) 2014 Tyson Leslie. All rights reserved.
//

#import "TTWindow.h"

@implementation TTWindow

- (instancetype)initWithWindowPosition:(TTWindowPosition)position {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        
        [self setWindowPosition:position];
        [self genericInit];
    }
    
    return self;
}

- (instancetype)init {
    
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        [self genericInit];
    }
    
    return self;
}

- (void)genericInit {
    
    self.clipsToBounds = YES;
    _supportedOrientation = UIInterfaceOrientationMaskAll;
}

- (void)setWindowPosition:(TTWindowPosition)windowPosition {
    
    if (_windowPosition == windowPosition) {
        return;
    }
    _windowPosition = windowPosition;
    [self willDisplay];
}

- (void)willDisplay {
    [self setWindowLevel:[self.class windowLevelForPosition:_windowPosition]];
}

/*!
 Translation method to return UIWindowLevel values from TTWindowPosition enum
 */
+ (UIWindowLevel)windowLevelForPosition:(TTWindowPosition)position {
    
    switch (position) {
        case TTWindowPositionModal:
            return UIWindowLevelNormal + 1;
            break;
            
        case TTWindowPositionTop:
            return UIWindowLevelStatusBar - 1;
            break;
            
        case TTWindowPositionDebug:
            return UIWindowLevelStatusBar + 1;
            break;
            
        case TTWindowPositionAlert:
            return UIWindowLevelAlert + 1;
            break;
            
        case TTWindowPositionStatusBar:
            return UIWindowLevelStatusBar + 1;
            break;
            
        case TTWindowPositionBackground:
            return UIWindowLevelNormal - 1;
            break;
            
        case TTWindowPositionBehind:
            return UIWindowLevelNormal;
            break;
            
            
        default:
            break;
    }
}


#pragma mark - Shake Gesture

/*!
 Handler for shake event
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        
        if (self.shakeGestureCallback) {
            self.shakeGestureCallback(YES);
        }
    }
}

@end
