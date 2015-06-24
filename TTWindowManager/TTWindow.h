//
//  TTWindow.h
//  ThatKit
//
//  Created by Tyson Leslie on 2014-03-04.
//  Copyright (c) 2014 Tyson Leslie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TTWindowBasicCompletion)();

/*!
 The z position of the window to be presented.
 
 @note window position can be presented above native elements like UIAlert and UIStatusBar. You can get some great effects through this like presenting a loading message above the status bar or a dismissable detail message over a UIAlert.
 */
typedef NS_ENUM(NSUInteger, TTWindowPosition) {
    TTWindowPositionModal = 100,
    TTWindowPositionTop = 140,
    TTWindowPositionDebug = 180,
    TTWindowPositionAlert = 220,
    TTWindowPositionStatusBar = 260
};

/*!
 The animation style used to present and dismiss the window
 */
typedef NS_ENUM(NSUInteger, TTWindowAnimationType) {
    TTWindowAnimationTypeNone,
    TTWindowAnimationTypeDefault,
    TTWindowAnimationTypeModal,
    TTWindowAnimationTypeFade
};


/*!
 @class TTWindow
 UIWindow subclass which can present any UIViewController subclass as a rootViewController. Normally an entire app is confined within a single UIWindow. This subclass allows you to create many TTWindow objects with different z positions for some truly creative UI.
 */
@interface TTWindow : UIWindow

/*!
 Determines which z position the window will be presented in
 */
@property (nonatomic) TTWindowPosition windowPosition;

/*!
 A referenece to the animation type used to present and dismiss the window
 */
@property (nonatomic) TTWindowAnimationType animationType;

/*!
 BOOL indicating if the window is on-screen
 */
@property (nonatomic) BOOL isPresented;

/*!
 An optional block callback fired when the user shakes their device
 */
@property (nonatomic, strong) TTWindowBasicCompletion shakeGestureCallback;

/*!
 @return an instance of TTWindow initialized with the provided window position
 */
- (instancetype)initWithWindowPosition:(TTWindowPosition)position;

@end
