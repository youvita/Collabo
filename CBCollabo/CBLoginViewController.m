//
//  LoginViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/23/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBLoginViewController.h"
#import "CBList102ViewController.h"
#import "CBWebViewViewController.h"
#import "SysUtils.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "AppUtils.h"
#import "SpinnerView.h"


#define kKeyboarOffset 25.0f

@interface CBLoginViewController (){
    UITextField *userName;
    UITextField *userPassword;
    NSDictionary *getSession;
    SpinnerView *spinner;
    NSString *url,*title;
}

@end

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultLeftButton = NO;
    self.defaultRightButton = NO;
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"로그인";
    
    
    userName = (UITextField *)[self.view viewWithTag:100];
    userPassword = (UITextField *)[self.view viewWithTag:101];
    
    userName.delegate = self;
    userPassword.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    userName.text = @"pykasd1";
    userPassword.text = @"qwer1234!";
}

#pragma mark - Request and Respond

- (void)sendTrans:(NSString *)tranCode{
    
    
    getSession = [[NSDictionary alloc]initWithDictionary:[SessionManager sharedSessionManager].loginDataDic];
    
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    [reqData setValue:userName.text forKey:@"USER_ID"];
    [reqData setValue:userPassword.text forKey:@"PWD"];
    [reqData setValue:[getSession objectForKey:kPortalID] forKey:@"PTL_ID"];
    [reqData setValue:[getSession objectForKey:kChannelID] forKey:@"CHNL_ID"];
    
    // save username and password
    if ([SessionManager sharedSessionManager].bIsLogin == YES) {
        [[SessionManager sharedSessionManager] setUserNameString:userName.text];
        [[SessionManager sharedSessionManager] setUserPassword:userPassword.text];
    }
    
    if ([SysUtils isNull:userName.text]) {
        [SysUtils showMessage:@"아니디 업습니다!"];
        return;
    }
    
    if([SysUtils isNull:userPassword.text]){
        [SysUtils showMessage:@"비밀번호 업습니다!"];
        return;
    }

    
    [SessionManager sharedSessionManager].serverUrlString = [getSession objectForKey:kCollaboURL];
    [super sendTransaction:tranCode requestDictionary:reqData];

}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
     [spinner removeSpinnerView]; // remove wating view
    
    if (responseArray == nil) {
//      [SysUtils showMessage:@"통신상태가 윈활하지 않습니다.[-1]"];
    }else{
        NSString *userID = responseArray[0][@"USER_ID"];
        [SessionManager sharedSessionManager].serverUrlString = [getSession objectForKey:kCollaboURL];
        [SessionManager sharedSessionManager].userID = userID;
        
        // Save Login Inforamtion
        NSMutableDictionary *saveData = [[NSMutableDictionary alloc] init];
        [saveData setObject:responseArray[0][@"USER_NM"] forKey:@"USER_NM"];
        [saveData setObject:responseArray[0][@"BSNN_NM"] forKey:@"BSNN_NM"];
        [saveData setObject:responseArray[0][@"CLPH_NO"] forKey:@"CLPH_NO"];
        [saveData setObject:responseArray[0][@"EML"] forKey:@"EML"];
        [saveData setObject:responseArray[0][@"PRFL_PHTG"] forKey:@"PRFL_PHTG"];
        [SessionManager sharedSessionManager].loginDataDic = saveData;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CBList102ViewController *listVC = [storyboard instantiateViewControllerWithIdentifier:@"CBList102ViewController"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    
}

#pragma mark - Button IB

- (IBAction)loginButtonPress:(UIButton *)sender {
    // wating view
    if ([SysUtils isNull:userName.text] || [SysUtils isNull:userPassword.text]) {
        
    }else{
        spinner = [SpinnerView loadSpinnerIntoView:self.view];

    }
    
    NSString *tranCd = @"COLABO_LOGIN_R001";
    [self sendTrans:tranCd];
}

- (IBAction)checkLogin:(UIButton *)sender {
    if (sender.selected == YES) {
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
        [[SessionManager sharedSessionManager] setBIsLogin:YES];// Save auto login
    }
}

- (IBAction)onGroupButtonPressed:(UIButton *)sender {
    
    NSMutableArray *menu_info = [SessionManager sharedSessionManager].menuArray;
   
    switch (sender.tag) {
        case 102:
            NSLog(@"Memeber");
            url = menu_info[0][@"c_member_url"];
            title = @"약관동의";
            break;
            
        case 103:
            NSLog(@"ForgotID");
            url = menu_info[0][@"c_forget_id_url"];
            title = @"아이디 찾기";
            break;
            
        case 104:
            NSLog(@"ForgotPw");
            url = menu_info[0][@"c_forget_pw_url"];
            title = @"비밀번호 찾기";
            break;
    }
    
    [self performSegueWithIdentifier:@"SegueCBWebView" sender:nil];
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CBWebViewViewController class]]){
        CBWebViewViewController *webView = segue.destinationViewController;
        webView.webTitle = title;
        webView.webUrl = url;
    }
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if( IS_IPHONE_5 )   return;
    
    if( textField == userPassword){
        [self setViewMoveUp:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
//    if( IS_IPHONE_5 )   return;
    
    if( textField == userPassword ){
        [self setViewMoveUp:NO];
    }
}


#pragma mark -
#pragma mark user defined methods

- (void)setViewMoveUp:(BOOL)move{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.0f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    
    if( move ){
        rect.origin.y   -= kKeyboarOffset;
    }else{
        rect.origin.y   += kKeyboarOffset;
        
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

    
@end
