//
//  CBSingupViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/3/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBSingupViewController.h"

@interface CBSingupViewController ()

@end

@implementation CBSingupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];    
    [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_logout_btn.png" highlightImageCode:@"top_logout_btn_p.png"];
    
    self.title = @"더보기";
    
    
    // Show profile information
    NSDictionary *getProfile = [[NSDictionary alloc]initWithDictionary:[SessionManager sharedSessionManager].loginDataDic];
    self.CBProfileName.text = getProfile[@"USER_NM"];
    self.CBProfileCompany.text = getProfile[@"BSNN_NM"];
    self.CBProfilePhone.text = [SysUtils getHyphenPhonNumber:getProfile[@"CLPH_NO"]];
    self.CBProfileMail.text = getProfile[@"EML"];
    
    NSString *imageFile = getProfile[@"PRFL_PHTG"];
    
    if (![SysUtils isNull:imageFile]) {
        
        NSURL *urlImage = [[NSURL alloc] initWithString:getProfile[@"PRFL_PHTG"]];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(q, ^{
            // Fetch the image from the server... /
            NSData *data = [NSData dataWithContentsOfURL:urlImage];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                //make rounded image
                self.CBProfileIcon.layer.cornerRadius = self.CBProfileIcon.frame.size.height /2;
                self.CBProfileIcon.layer.masksToBounds = YES;
                self.CBProfileIcon.layer.borderWidth = 0;
                self.CBProfileIcon.image =img;
            });
        });
    }
    
    // Show app information
    UIButton *bizplaySchedule = (UIButton *)[self.view viewWithTag:1];
    UIButton *greenMessage = (UIButton *)[self.view viewWithTag:4];
    
    NSMutableArray *getAppInfo = [[NSMutableArray alloc] initWithArray:[SessionManager sharedSessionManager].appInfoDataArr];
    for (int i = 0; i<getAppInfo.count; i++) {
        BOOL c_available = [getAppInfo[i][@"c_available"] boolValue];
        NSString *c_app_id = getAppInfo[i][@"c_app_id"];
//        NSString *c_app_url = getAppInfo[i][@"c_app_url"];
        
        if ([c_app_id isEqualToString:@"bizplaySchedule"]) {
            if (c_available == true) {
                [bizplaySchedule setSelected:YES];
            }
        }
        if([c_app_id isEqualToString:@"GreenMessage"]){
            if (c_available == true) {
                [greenMessage setSelected:YES];
            }
        }
 
    }
    
    // Show version app
    self.CBAppVersion.text = [SessionManager sharedSessionManager].latestVersion;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onAlarmRowPress:(UITapGestureRecognizer *)sender {
}

- (IBAction)onMoreRowPress:(UITapGestureRecognizer *)sender {
}

- (IBAction)onGroupAppButtonPress:(UIButton *)sender {
}
@end
