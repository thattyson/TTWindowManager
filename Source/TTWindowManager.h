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

@interface TTWindowManager : NSObject

+ (instancetype)sharedInstance;

/*!
 @return Window or nil for the passed window position
 */
- (TTWindow *)windowForPosition:(TTWindowPosition)position;

/*!
 @return the apps window frame
 */
- (CGRect)windowFrame;

- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position;
- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position withAnimation:(TTWindowAnimationType)animation;
- (void)presentViewController:(UIViewController *)viewController atWindowPosition:(TTWindowPosition)position withAnimation:(TTWindowAnimationType)animation completion:(TTWindowBOOLCompletion)completion;

- (void)dismissViewControllerAtWindowPosition:(TTWindowPosition)position;
- (void)dismissViewControllerAtWindowPosition:(TTWindowPosition)position completion:(TTWindowBOOLCompletion)completion;

@end
