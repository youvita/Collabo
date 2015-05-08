//
//  AppDelegate.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/18/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "AppDelegate.h"
#import "CBLoginViewController.h"
#import "CBList102ViewController.h"
#import "CBCreateViewController.h"

@interface AppDelegate (){
    BOOL isRespondLogin;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self sendTran];
    // Check the first set up intro screen
    if ([SessionManager sharedSessionManager].isFirstSetUp) {
        // if no it mean not auto login
        if ([SessionManager sharedSessionManager].bIsLogin == NO) {
            
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CBCreateViewController * Loginvc = [storyboard instantiateViewControllerWithIdentifier:@"CBCreateViewController"];
            [self.navigation pushViewController:Loginvc animated:NO];

//            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            CBLoginViewController * Loginvc = [storyboard instantiateViewControllerWithIdentifier:@"CBLoginViewController"];
//            [self.navigation pushViewController:Loginvc animated:NO];
        }
    }else{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.CBIntro = [[CBIntroViewController alloc] initWithNibName:@"CBAppIntro" bundle:nil];
        } else {
            self.CBIntro = [[CBIntroViewController alloc] initWithNibName:@"CBAppIntro" bundle:nil];
        }
        self.navigation = [[UINavigationController alloc] initWithRootViewController:self.CBIntro];
        self.window.rootViewController = self.navigation;
        
        [self.window makeKeyAndVisible];
        
    }

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)sendTran{
    isRespondLogin = NO;
    [AppUtils showWaitingSplash];
    [SessionManager sharedSessionManager].serverUrlString = mgURL;
    [SecurityManager sharedSecurityManager].delegate = self;
    [[SecurityManager sharedSecurityManager]willConnect:nil query:nil method:TRANS_METHOD_POST];
}

- (void)returnResult:(NSString *)returnResult errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    
    NSDictionary *resObject = [returnResult JSONValue];
    
    if (isRespondLogin == NO) {
        NSDictionary *resData = [[NSDictionary alloc] initWithDictionary:[resObject objectForKey:kTransResponseData]];
        NSArray *resRec = [[NSArray alloc] initWithArray:[resData objectForKey:@"_tran_res_data"]];
        
        // Save Menu Information
        NSMutableArray *saveMenuInfo = [[NSMutableArray alloc] init];
        saveMenuInfo = resRec[0][@"_menu_info"];
        [SessionManager sharedSessionManager].menuArray = saveMenuInfo;
        
        // Save App Information
        NSMutableArray *saveAppInfo = [[NSMutableArray alloc] init];
        saveAppInfo = resRec[0][@"_app_info"];
        [SessionManager sharedSessionManager].appInfoDataArr = saveAppInfo;
        
        // Save Login Inforamtion
        NSMutableDictionary *saveData = [[NSMutableDictionary alloc] init];
        [saveData setObject:resRec[0][kChannelID] forKey:kChannelID];
        [saveData setObject:resRec[0][kPortalID] forKey:kPortalID];
        [saveData setObject:[NSString stringWithFormat:@"%@?",resRec[0][kCollaboURL]] forKey:kCollaboURL];
        
        [SessionManager sharedSessionManager].loginDataDic = saveData;
        
        NSString *lastVersion = resRec[0][@"c_program_ver"];
        [[SessionManager sharedSessionManager] setLatestVersion:lastVersion];

        if ([SessionManager sharedSessionManager].bIsLogin == YES) {
            NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
            [reqData setValue:[SessionManager sharedSessionManager].userNameString forKey:@"USER_ID"];
            [reqData setValue:[SessionManager sharedSessionManager].userPassword forKey:@"PWD"];
            [reqData setValue:resRec[0][kPortalID] forKey:@"PTL_ID"];
            [reqData setValue:resRec[0][kChannelID] forKey:@"CHNL_ID"];
            
            [SessionManager sharedSessionManager].serverUrlString = [NSString stringWithFormat:@"%@?",resRec[0][kCollaboURL]];
            [self sendTransaction:@"COLABO_LOGIN_R001" requestDictionary:reqData];
            isRespondLogin = YES;
        }
    }else{
        if ([SessionManager sharedSessionManager].bIsLogin == YES) {
            NSString *resAPIKey = resObject[kTransCode];
            NSDictionary *getSession = [[NSDictionary alloc]initWithDictionary:[SessionManager sharedSessionManager].loginDataDic];
            if ([resAPIKey isEqualToString:@"COLABO_LOGIN_R001"]) {
                NSString *userID = resObject[kTransResponseData][0][@"USER_ID"];
                [SessionManager sharedSessionManager].serverUrlString = [getSession objectForKey:kCollaboURL];
                [SessionManager sharedSessionManager].userID = userID;

                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CBList102ViewController * Listvc = [storyboard instantiateViewControllerWithIdentifier:@"CBList102ViewController"];
                [self.navigation pushViewController:Listvc animated:NO];

            }
        }
    }
    
    
    
}

- (void)sendTransaction:(NSString *)transCode requestDictionary:(NSDictionary *)requestDictionary{
    [AppUtils showWaitingSplash];
    [SecurityManager sharedSecurityManager].delegate = self;
    
    NSMutableDictionary *reqDocument = [[NSMutableDictionary alloc] init];
    [reqDocument setObject:transCode forKey:kTransCode];
    [reqDocument setObject:kAuthenticationKey forKey:@"CNTS_CRTC_KEY"];
    [reqDocument setObject:requestDictionary forKey:kTransRequestData];
    
#if _DEBUG_
    NSLog(@"Request Trans[%@]", [reqDocument JSONRepresentation]);
#endif
    
    if (![[SecurityManager sharedSecurityManager] willConnect:nil query:[reqDocument JSONRepresentation] method:TRANS_METHOD_POST]) {
//        [SysUtils showMessage:@"인터넷이 원활하지 않습니다. 잠시 후 다시 시도하여 주십시오."];
        return;
    }
    
}



@end
