//
//  TTWindowManager.h
//  ThatKit
//
//  Created by Tyson Leslie on 2014-03-04.
//  Copyright (c) 2014 Tyson Leslie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTWindow.h"

typedef void(^TTWindowBOOLCompletion)(BOOL successful);

/*!
 @class TTWindowManager
 Manages the presentation and dismissal of all TTWindows.
 */
@interface TTWindowManager : NSObject

/*!
 @return the global instance of TTWindowManager
 */
+ (instancetype)sharedInstance;

/*!
 @return Window or nil for the passed window position
 */
- (TTWindow *)windowForPosition:(TTWindowPosition)position;

/*!
 @return the apps window frame
 */
- (CGRect)windowFrame;

/*!
 @return The top-most window in the window heirarchy
 */
- (UIWindow *)topVisibleWindow;


- (void)setBackgroundColor:(UIColor *)color;



/*!
 Presents the passed view controller on a TTWindow at the provided z position
 */
- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position;
/*!
 Presents the passed view controller on a TTWindow at the provided z position using the provided animation.
 */
- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position withAnimation:(TTWindowAnimationType)animation;
/*!
 Presents the passed view controller on a TTWindow at the provided z position using the provided animation with a block completion callback.
 */
- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position withAnimation:(TTWindowAnimationType)animation completion:(TTWindowBOOLCompletion)completion;


/*!
 Dismisses the window and all views at the provided z position
 */
- (void)dismissViewControllerAtWindowPosition:(TTWindowPosition)position;

/*!
 Dismisses the window and all views at the provided z position with a block completion callback.
 */
- (void)dismissViewControllerAtWindowPosition:(TTWindowPosition)position completion:(TTWindowBOOLCompletion)completion;





/*!
 An optional block callback fired when the debugger is paused and resumed - great for adding a callback within an error-prone controller that is hard to debug.
 
 @note This will fire any time you pause the debugger!
 */
@property (nonatomic, strong) TTWindowBasicCompletion debuggerPauseCallback;

@end
