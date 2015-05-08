//
//  CBWebViewViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/31/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBWebViewViewController.h"

@interface CBWebViewViewController ()

@end

@implementation CBWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];
    
    self.navigationItem.hidesBackButton = YES;
    self.title = self.webTitle;
    
    SpinnerView *spinner = [SpinnerView loadSpinnerIntoView:self.view];
    NSURL *url = [NSURL URLWithString:self.webUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             [_webView loadRequest:request];
             [spinner removeSpinnerView];
         }
         else if (error != nil){ NSLog(@"Error: %@", error);}
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
