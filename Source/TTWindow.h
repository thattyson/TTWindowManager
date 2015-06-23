//
//  TTWindow.h
//  ThatKit
//
//  Created by Tyson Leslie on 2014-03-04.
//  Copyright (c) 2014 Tyson Leslie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TTWindowBasicCompletion)();

typedef enum {
    TTWindowPositionModal = 100,
    TTWindowPositionTop = 140,
    TTWindowPositionDebug = 180
}TTWindowPosition;

typedef enum {
    TTWindowAnimationTypeNone,
    TTWindowAnimationTypeDefault,
    TTWindowAnimationTypeModal,
    TTWindowAnimationTypeFade
} TTWindowAnimationType;

@interface TTWindow : UIWindow

@property (nonatomic) TTWindowPosition windowPosition;
@property (nonatomic) TTWindowAnimationType animationType;
@property (nonatomic) BOOL isPresented;
@property (nonatomic, strong) TTWindowBasicCompletion shakeGestureCallback;

- (instancetype)initWithWindowPosition:(TTWindowPosition)position;

@end
