//
//  ToastView.h
//  Bizplay
//
//  Created by knm on 2014. 10. 27..
//  Copyright (c) 2014년 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView {
    
    NSTimer *_timer;
}

- (id)initWithFrameAndMessage:(CGRect)frame message:(NSString *)message;

- (void)start;

@end
