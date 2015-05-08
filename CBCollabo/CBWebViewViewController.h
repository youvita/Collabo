//
//  CBWebViewViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 3/31/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "Constants.h"
#import "AllUtils.h"
#import "SpinnerView.h"

@interface CBWebViewViewController : WCViewController

@property (strong, nonatomic)NSString *webUrl;
@property (strong, nonatomic)NSString *webTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
