//
//  TTWindowManager.m
//  ThatKit
//
//  Created by Tyson Leslie on 2014-03-04.
//  Copyright (c) 2014 Tyson Leslie. All rights reserved.
//

#import "TTWindowManager.h"

typedef enum {
    TTAnimationDirectionPush,
    TTAnimationDirectionPop
}TTAnimationDirection;

@interface TTWindowManager ()

@property (nonatomic, strong) NSMutableDictionary *windows;
@property (nonatomic, strong) TTWindow *backgroundAnimationWindow;

@end

@implementation TTWindowManager

+ (instancetype)sharedInstance {
    static TTWindowManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTWindowManager alloc]init];
    });
    
    return sharedInstance;
}


#pragma mark - Presentation

- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position {
    
    [self presentViewController:viewController atWindowPosition:position withAnimation:TTWindowAnimationTypeDefault];
}

- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position withAnimation:(TTWindowAnimationType)animation {
    
    [self presentViewController:viewController atWindowPosition:position withAnimation:animation completion:nil];
}

- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position withAnimation:(TTWindowAnimationType)animation completion:(TTWindowBOOLCompletion)completion {
    
    TTWindow *windowToPresent = [self windowForPosition:position];
    windowToPresent.animationType = animation;
    
    NSAssert(![windowToPresent isPresented], @"Attempting to display %@ when a viewController is already being displayed for window position %lu", viewController, position);
    
    windowToPresent.rootViewController = viewController;
    [self displayWindow:windowToPresent completion:completion];
}


#pragma mark - Dismissal

- (void)dismissViewControllerAtWindowPosition:(TTWindowPosition)position {
    
    [self dismissViewControllerAtWindowPosition:position completion:nil];
}

- (void)dismissViewControllerAtWindowPosition:(TTWindowPosition)position completion:(TTWindowBOOLCompletion)completion {
    
    TTWindow *windowToDismiss = [self windowForPosition:position];
    [self hideWindow:windowToDismiss completion:completion];
}


#pragma mark - Window Management

- (CGRect)windowFrame {
    
    return [[[UIApplication sharedApplication] delegate] window].frame;
}

- (TTWindow *)windowForPosition:(TTWindowPosition)position {
    
    if (self.windows[[self.class keyForWindowPosition:position]]) {
        
        return self.windows[[NSString stringWithFormat:@"%lu", (unsigned long)position]];
    }
    
    TTWindow *newWindow = [[TTWindow alloc]initWithWindowPosition:position];
    [self.windows setObject:newWindow forKey:[self.class keyForWindowPosition:position]];
    
    return newWindow;
}

+ (NSString*)keyForWindowPosition:(TTWindowPosition)position {
    
    return [NSString stringWithFormat:@"%lu", (unsigned long)position];
}

- (NSMutableDictionary *)windows {
    if (!_windows) {
        _windows = [[NSMutableDictionary alloc] init];
    }
    
    return _windows;
}

- (UIWindow *)topVisibleWindow {
    
    TTWindow *topPresentedWindow = nil;
    
    for (TTWindow *window in [self.windows allValues]) {
        
        if (window.isPresented) {
            
            if (!topPresentedWindow) {
                topPresentedWindow = window;
                continue;
            }
            
            if (window.windowPosition > topPresentedWindow.windowPosition) {
                topPresentedWindow = window;
            }
        }
    }
    
    if (!topPresentedWindow) {
        return [[[UIApplication sharedApplication] delegate] window];
    }
    
    return topPresentedWindow;
}


#pragma mark - Animation

//TODO: add an optional image for the background view instead of strictly black
- (TTWindow *)backgroundAnimationWindow {
    
    if (!_backgroundAnimationWindow) {
        _backgroundAnimationWindow = [[TTWindow alloc]init];
        _backgroundAnimationWindow.backgroundColor = [UIColor blackColor];
        
    }
    
    return _backgroundAnimationWindow;
}

- (void)displayBackgroundAnimationWindowBelowWindow:(UIWindow*)window {
    
    if (![self backgroundAnimationWindow].isPresented) {
        [[self backgroundAnimationWindow] setWindowLevel:window.windowLevel - 1];
        [[self backgroundAnimationWindow] makeKeyAndVisible];
        [self backgroundAnimationWindow].isPresented = YES;
    }
}

- (void)hideBackgroundAnimationWindow {
    
    if ([self backgroundAnimationWindow].isPresented) {
        [self backgroundAnimationWindow].hidden = YES;
        [self backgroundAnimationWindow].isPresented = NO;
    }
}

- (void)displayWindow:(TTWindow*)window completion:(TTWindowBOOLCompletion)completion {
    
    if(!window.isPresented) {
        
        UIWindow *previousWindow = [self topVisibleWindow];
        
        if ([previousWindow isKindOfClass:[TTWindow class]]) {
            
            TTWindow *ttWindow = (TTWindow*)previousWindow;
            if (ttWindow.shakeGestureCallback) {
                
                window.shakeGestureCallback = ttWindow.shakeGestureCallback;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self animateIncomingWindow:window andOutgoingWindow:previousWindow withAnimationType:window.animationType andDirection:TTAnimationDirectionPush completion:completion];
        });
    } else {
        
        if (completion)completion(NO);
    }
}

- (void)hideWindow:(TTWindow*)window completion:(TTWindowBOOLCompletion)completion {
    
    window.shakeGestureCallback = nil;
    if(window.isPresented) {
        
        window.isPresented = NO;
        UIWindow *previousWindow = [self topVisibleWindow];
        window.isPresented = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self animateIncomingWindow:window andOutgoingWindow:previousWindow withAnimationType:window.animationType andDirection:TTAnimationDirectionPop completion:^(BOOL successful) {
                
                [self notifyWindowWillAppear:(TTWindow*)previousWindow];
                [self notifyWindowDidAppear:(TTWindow*)previousWindow];
                if (completion) completion(successful);
            }];
        });
    } else {
        
        if (completion)completion(NO);
    }
}

- (void)notifyWindowWillAppear:(TTWindow*)window {
    
    if (![window isKindOfClass:[TTWindow class]]) return;
    
    [window.rootViewController viewWillAppear:(window.animationType != TTWindowAnimationTypeNone)];
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        if (((UINavigationController*)window.rootViewController).topViewController) {
            
            [((UINavigationController*)window.rootViewController).topViewController viewWillAppear:(window.animationType != TTWindowAnimationTypeNone)];
        }
    }
}

- (void)notifyWindowDidAppear:(TTWindow*)window {
    
    if (![window isKindOfClass:[TTWindow class]]) return;
    
    [window.rootViewController viewDidAppear:(window.animationType != TTWindowAnimationTypeNone)];
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        if (((UINavigationController*)window.rootViewController).topViewController) {
            
            [((UINavigationController*)window.rootViewController).topViewController viewDidAppear:(window.animationType != TTWindowAnimationTypeNone)];
        }
    }
}

- (void)animateIncomingWindow:(TTWindow*)incomingWindow andOutgoingWindow:(UIWindow*)outgoingWindow withAnimationType:(TTWindowAnimationType)animationType andDirection:(TTAnimationDirection)direction completion:(TTWindowBOOLCompletion)completion {
    
    switch (animationType) {
        case TTWindowAnimationTypeDefault:
            [self fadeIncomingWindow:incomingWindow andOutgoingWindow:outgoingWindow withDirection:direction completion:completion];
            break;
            
        case TTWindowAnimationTypeFade:
            [self fadeIncomingWindow:incomingWindow andOutgoingWindow:outgoingWindow withDirection:direction completion:completion];
            break;
            
        case TTWindowAnimationTypeModal:
            [self modalIncomingWindow:incomingWindow andOutgoingWindow:outgoingWindow withDirection:direction completion:completion];
            break;
            
        case TTWindowAnimationTypeNone:
            [self normalizeIncomingWindow:incomingWindow andOutgoingWindow:outgoingWindow withDirection:direction completion:completion];
            break;
            
        default:
            break;
    }
}

- (void)fadeIncomingWindow:(TTWindow*)incomingWindow andOutgoingWindow:(UIWindow*)outgoingWindow withDirection:(TTAnimationDirection)direction completion:(TTWindowBOOLCompletion)completion {

    if (direction == TTAnimationDirectionPush) {
        incomingWindow.alpha = 0.0f;
        [incomingWindow setHidden:NO];
    } else if (direction == TTAnimationDirectionPop) {
        
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        if (direction == TTAnimationDirectionPush) {
            incomingWindow.alpha = 1.0f;
        } else if (direction == TTAnimationDirectionPop) {
            incomingWindow.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        
        [self normalizeIncomingWindow:incomingWindow andOutgoingWindow:outgoingWindow withDirection:direction completion:completion];
    }];
}

- (void)modalIncomingWindow:(TTWindow*)incomingWindow andOutgoingWindow:(UIWindow*)outgoingWindow withDirection:(TTAnimationDirection)direction completion:(TTWindowBOOLCompletion)completion {
    [self displayBackgroundAnimationWindowBelowWindow:outgoingWindow];
    
    CGRect finalFrame = incomingWindow.frame;
    CGRect dismissedFrame = incomingWindow.bounds;
    dismissedFrame.origin.y = dismissedFrame.size.height;
    
    if (direction == TTAnimationDirectionPush) {
        [incomingWindow setHidden:NO];
        incomingWindow.frame = dismissedFrame;
    }
    
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
        
        if (direction == TTAnimationDirectionPush) {
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.4 animations:^{
                outgoingWindow.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                outgoingWindow.alpha = 0.4f;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:1.0 animations:^{
                incomingWindow.frame = finalFrame;
            }];
        } else if (direction == TTAnimationDirectionPop) {
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.6 animations:^{
                incomingWindow.frame = dismissedFrame;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:1.0 animations:^{
                outgoingWindow.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                outgoingWindow.alpha = 1.0f;
            }];
        }
    } completion:^(BOOL finished) {
        
        if (direction == TTAnimationDirectionPop) {
            
            incomingWindow.frame = finalFrame;
        }
        
        [self normalizeIncomingWindow:incomingWindow andOutgoingWindow:outgoingWindow withDirection:direction completion:completion];
        [self hideBackgroundAnimationWindow];
    }];
}

- (void)normalizeIncomingWindow:(TTWindow*)incomingWindow andOutgoingWindow:(UIWindow*)outgoingWindow withDirection:(TTAnimationDirection)direction completion:(TTWindowBOOLCompletion)completion {
    
    if (direction == TTAnimationDirectionPush) {
        
        [incomingWindow makeKeyAndVisible];
        incomingWindow.alpha = 1.0f;
        incomingWindow.isPresented = YES;
    } else if (direction == TTAnimationDirectionPop) {
        
        incomingWindow.hidden = YES;
        incomingWindow.rootViewController = nil;
        incomingWindow.isPresented = NO;
        [outgoingWindow makeKeyAndVisible];
    }
    
    if (completion)completion(YES);
}

@end
