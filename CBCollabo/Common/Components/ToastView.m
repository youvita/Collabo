//
//  ToastView.m
//  Bizplay
//
//  Created by knm on 2014. 10. 27..
//  Copyright (c) 2014년 webcash. All rights reserved.
//

#import "ToastView.h"
#import "AllUtils.h"
#import "Constants.h"

@implementation ToastView

- (void)stop {
    
    [UIView animateWithDuration:1.0
                     animations:^{self.alpha = 0.0;}
                     completion:^(BOOL finished){
                         //self.hidden = YES;
                     }];
    
    if (_timer != nil) {
        
        [_timer invalidate];
        _timer = nil;
        
    }
    
}


- (void)start {
    
    self.hidden = NO;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(stop) userInfo:nil repeats:NO];
    
}


- (id)initWithFrameAndMessage:(CGRect)frame message:(NSString *)message {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 이미지
        UIImage *image = [UIImage imageNamed:@"gb_receive_box.png"];
        
        UIImageView *imageView       = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
        imageView.frame              = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        imageView.backgroundColor    = RGBA(10, 10, 10, 0.8);
        imageView.layer.cornerRadius = 25.0f;
        [self addSubview:imageView];
        
        // 메시지
        UILabel *label          = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, imageView.frame.size.height/2 - (imageView.frame.size.height - 20.0f)/2, imageView.frame.size.width - 20.0f, imageView.frame.size.height - 20.0f)];
        label.backgroundColor   = [UIColor clearColor];
        label.font              = [UIFont systemFontOfSize:12.0f];
        label.textAlignment     = NSTextAlignmentCenter;
        label.textColor         = RGB(255, 255, 255);
        label.numberOfLines     = 0;
        label.text              = message;
        [self addSubview:label];
        
    }
    
    return self;
}


@end
