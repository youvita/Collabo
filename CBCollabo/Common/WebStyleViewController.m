//
//  WebStyleViewController.m
//  iBrowser
//
//  Created by 종욱 윤 on 10. 3. 27..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "WebStyleViewController.h"
#import "Constants.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "SysUtils.h"
#import "AppUtils.h"
#import "JSON.h"
#import "UserSettings.h"


@interface WebStyleViewController()
- (void)sendTrData:(NSString *)docID;
@end


@implementation WebStyleViewController

@synthesize menuURL				= _menuURL;


- (void)internalInit {
	if (self == nil)
		return;
	
    //	_path							= nil;Jsonlib
    //	_originalParams					= nil;
	_isAppBackAction				= YES;
	_isImageOpen					= NO;
	_isTrSend                       = NO;
	_currentImagePage				= 1;
	urlFirstString                  = @"";
    urlAllString                    = @"";
}


- (id)init {
	self = [super init];
	
	if ([SysUtils isNull:self] == NO)
		[self internalInit];
	
	return self;
}


- (id)initWithURL:(NSString *)aURL {
	self = [self init];
	
	if ([SysUtils isNull:self] == NO) {
		[self internalInit];
		
        _isImageOpen = YES;
		_menuURL = aURL;
	}
	
	return self;
}


// 첨부파일의 pdf 파일 open을 위한 init 함수
- (id)initWithPDFURL:(NSString *)aURL {
    self = [self init];
    
    if ([SysUtils isNull:self] == NO) {
        [self internalInit];
        
        _isOpenPDF = YES; // 첨부파일의 pdf 파일 구분 값
        
        _isImageOpen = YES;
        _menuURL = aURL;
    }
    
    return self;
}


- (void)getrendomkey{
    //    if ([[SecurityManager sharedSecurityManager] isCanCancel]) {
    //        [[SecurityManager sharedSecurityManager] cancelTransaction];
    //
    //        [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    //    }
    //
    //    [AppUtils showWaitingSplash];
    //
    //    NSMutableDictionary *reqDetail = [[NSMutableDictionary alloc] initWithCapacity:4];
    //
    //    [reqDetail setObject:[SessionManager sharedSessionManager].userID       forKey:@"USER_ID"];             // 사용자ID
    //
    //	[super sendTransaction:@"sso_randomkey_create" requestDictionary:reqDetail];
    //	[reqDetail release];
}



- (id)initWithParams:(NSDictionary *)aParams {
	self = [super init];
	
	if ([SysUtils isNull:self] == NO) {
		[self internalInit];
		
#if _DEBUG_
		NSLog(@"========================================");
		NSLog(@"WebStyleViewController ========  aParams[%@]", [aParams description]);
		NSLog(@"========================================");
#endif
		
		if ([SysUtils isNull:aParams] == NO) {
            
            NSString* sTargetURL = nil;
//            sTargetURL = [NSString stringWithFormat:@"%@%@%@", _SM_GATEWAY_URL, _SM_GATEWAY_PATHURL,[aParams objectForKey:@"LINK_URL1"]];

            
            self.title = [SessionManager sharedSessionManager].menuTitleString;
            
            if ([SysUtils isNull:sTargetURL] == NO)
                _menuURL = [sTargetURL copy];
        }
        
	}
	
	return self;
}


- (void)backbuttonClicked:(UIButton *)button {
    if ([urlFirstString isEqualToString:urlAllString]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [_web goBack];
    }
    
}


- (void)goBack:(NSNotification *)note {
	[self backbuttonClicked:nil];
}



- (NSArray *)getTabItems {
	UITabBarItem *tabItem		= nil;
	NSMutableArray *resultArray = [[NSMutableArray alloc] init];
	
//	tabItem = [[UITabBarItem alloc] initWithTitle:@"이전" image:[UIImage imageNamed:@"i_icon_c2.png"] tag:1];
//	[resultArray addObject:tabItem];
//	tabItem.enabled = YES;
//	[tabItem release];
//	
//	tabItem = [[UITabBarItem alloc] initWithTitle:@"다음" image:[UIImage imageNamed:@"i_icon_c3.png"] tag:2];
//	[resultArray addObject:tabItem];
//	tabItem.enabled = YES;
//	[tabItem release];
	
	return resultArray;
}

- (void)sendTrData:(NSString *)docID {
    //	if ([[SecurityManager sharedSecurityManager] isCanCancel] == YES) {
    //		[[SecurityManager sharedSecurityManager] cancelTransaction];
    //	}
	
    //
    //	[AppUtils showWaitingSplash];
    //
    //	NSMutableDictionary *dicTrData = [[NSMutableDictionary alloc] init];
    //	NSString *sTransCode = @"CM0610";
    //
    //	[dicTrData setObject:docID forKey:@"DOCID"];
    //
    //	NSArray *arrTrans = [NSArray arrayWithObject:dicTrData];
    //
    //	//common data
    //	NSMutableDictionary *dicGateInput = [[NSMutableDictionary alloc] init];
    //	[dicGateInput setObject:sTransCode forKey:kTransCode];
    //	[dicGateInput setObject:arrTrans forKey:kTransRequestData];
    //
    //	[SecurityManager sharedSecurityManager].delegate = self;
    //	[[SecurityManager sharedSecurityManager] willConnect:nil query:[dicGateInput JSONRepresentation] method:TRANS_METHOD_POST];
    //
    //	[dicTrData release];
    //	[dicGateInput release];
}

// 하단의 메뉴 뷰 클릭시
- (void)barEventButtonClicked:(UIButton *)button {
	isTrDetail = NO;
	
    UIViewController *calleeCtrl = nil;
    UIAlertView *alert = nil;
    
    switch (button.tag) {
        case 2001: // 홈
            [[NSNotificationCenter defaultCenter] postNotificationName:kNaviBarShowNotification object:self userInfo:nil];
			[self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        case 2002: // 새로고침
            // 설정에 따른 편지함 전문
            //            stIndex			= 1;
            //            enIndex			= iMoreSeeCount;
            //
            //            isRefresh	    = YES;
            //
            //            [self transMailData:pageIndex];
            [_web reload];
            
            break;
            
        case 2003: // 뒤로가기
            [_web goBack];
            ((UIButton *)[self.view viewWithTag:2003]).hidden = YES;
            
            break;
        case 2008: // 로그아웃
            alert = [[UIAlertView alloc] initWithTitle:@"확인"
                                               message:@"로그아웃 하시겠습니까?\n로그아웃 하시면 재로그인이 필요합니다."
                                              delegate:self
                                     cancelButtonTitle:@"취소"
                                     otherButtonTitles:@"확인", nil];
            alert.tag = 9997;
            
            [alert show];
            [alert release];
            break;
            
            //        case 2004: // 삭제
            //            if (isSearchMode) return;
            //
            //            [self deleteConfirm:0];
            //            break;
            //
            //        case 2006: // 전체삭제
            //            if (isSearchMode) return;
            //            if ([SysUtils isNull:_mailDeleteArray] == NO) {
            //                [_mailDeleteArray  removeAllObjects];
            //            }
            //
            //            for (int i=0; i < [_mailListArray count]; i++) {
            //                [_mailDeleteArray addObject:[NSNumber numberWithInt:i]];
            //            }
            //#if _DEBUG_
            //            NSLog(@"------------------ _mailListArray [%d][%@]",[_mailListArray count], _mailListArray);
            //            NSLog(@"------------------ _mailDeleteArray [%d][%@]", [_mailDeleteArray count],_mailDeleteArray);
            //#endif
            //            [self deleteConfirm:0];
            //            break;
    }
	
}


#pragma mark -
#pragma mark UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (alertView.tag) {
        case 9997: // 로그아웃 처리
			if (buttonIndex == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNaviBarShowNotification object:self userInfo:nil];
				NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:kErrorActionCodeGoToHomeAfterLogout, kKeyOfErrorAction, nil];
				[[NSNotificationCenter defaultCenter] postNotificationName:kExecuteErrorActionNotification object:self userInfo:tempDic];
			}
			break;
	}
	
}


#pragma mark-
#pragma mark Application lifecycle methods
#pragma mark-

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn.png"];

	_isAppBackAction = NO;
    //    self.view.backgroundColor = [UIColor greenColor];
    //	CGRect selfViewBounds = self.view.bounds;
    //			const CGFloat TabBarSize = 76.0;
    _web = [[UIWebView alloc] init];
	_web.backgroundColor		= [UIColor viewFlipsideBackgroundColor];
	_web.scalesPageToFit		= YES;
	_web.dataDetectorTypes		= UIDataDetectorTypeLink;
	_web.delegate				= self;
    _web.scrollView.bounces = NO;
    //	_web.autoresizingMask		= (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
	[self.view addSubview:_web];
    
    //
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"bg_title.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    _web.frame		= CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64);
    
    // 첨부파일의 pdf 파일 open을 위한 분기 처리
    if (_isOpenPDF) {
        
//        NSURL *url = [[NSURL alloc] initWithString:_menuURL];
//        NSError *error = nil;
//        
//        // get data from url link
//        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error]; //NSDataReadingUncached
//        
//        // error
//        if (error) {
//            [SysUtils showMessage:@"파일 로딩에 실패하였습니다."];
//            return;
//        }
//        
//        // load request from binaray data
//        [_web loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:nil]]; //@"http://example.com/"
        
        
        // use WCPDFView
        NSURL *pdfURL = [NSURL fileURLWithPath:_menuURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
        [_web loadRequest:request];
        
    } else {
        
        //URL Open
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_menuURL]];
        //	[[SecurityManager sharedSecurityManager] loadRequest:req];
        [_web loadRequest:req];
        
    }
    
    //URL Open
    NSURLRequest *req	= [NSURLRequest requestWithURL:[NSURL URLWithString:_menuURL]];
    //	[[SecurityManager sharedSecurityManager] loadRequest:req];
    [_web loadRequest:req];
	
    //	if (_isImageOpen) {
    //		_mainTab = [[UITabBar alloc] initWithFrame:CGRectMake(0.0f, 480.0f - 64.0f - 49.0f, 320.0f, 49.0f)];
    //		_mainTab.items = [self getTabItems];
    //		_mainTab.delegate = self;
    //
    //		[self.view addSubview:_mainTab];
    //		_mainTab.userInteractionEnabled = YES;
    //	} else {
    //		//todo : tabview 생성
    //
    ///*  TODO: 나중에 확인후 다시 주석 제거
    //		AprvRcvTabView *tabView = [[AprvRcvTabView alloc] initWithFrame:CGRectMake(0, selfViewBounds.size.height-76, selfViewBounds.size.width, TabBarSize)];
    //		tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    //		[self.view addSubview:tabView];
    //		[tabView release];
    //*/
    //
    //	}
    
	
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
//		if (_isImageOpen) {
//			_mainTab.frame = CGRectMake(0.0f, 480.0f - 64.0f - 49.0f, 320.0f, 49.0f);
//		}
//	} else {
//		if (_isImageOpen) {
//			_mainTab.frame = CGRectMake(0.0f, 320.0f - 52.0f - 49.0f, 480.0f, 49.0f);
//		}
//	}
//    
	
	
	return YES;
}


- (void)viewDidUnload {
	//[SecurityManager sharedSecurityManager].delegate = nil;
    
	[super viewDidUnload];
}


- (void)dealloc {
    _web.delegate = nil;
    
	if (_imageURL) {
		[_imageURL release];
	}
	
	if (_docID) {
		[_docID release];
	}
    
	if ([SysUtils isNull:_mainTab] == NO) {
		[_mainTab release];
	}
    
    [super dealloc];
}



#pragma mark -
#pragma UITabBarDelegate
#pragma mark -

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	switch (item.tag){
		case 1:
			if (_web.canGoBack && _currentImagePage > 1) {
				[_web goBack];
				
				_currentImagePage--;
			}
			break;
			
		case 2:
			/* ================================================================================
             1. _currentImagePage = 1 인경우 'CM0610'전문 통신하여 서버 응답에 따른 페이징 처리한다.
             전문 수신후 2페이지 존지하는 경우 CM0606.act 호출하여 페이지 표시한다.
             2. _currentImagePage > 1 인경우 아래 기존 로직 그대로 사용한다.
             ================================================================================= */
			
			if ((_currentImagePage == 1) && (_isTrSend == NO)) {
				// CM0610전문호출 (CM0605와 동일 스펙이나 2번째 페이지 부터 호출하는 경우 사용됨. 첫번째 페이지는 CM0605로 사용함)
				[self sendTrData:_docID];
				
			} else {
				// 이미 CM0610전문을 사용한 이후이기에 _maxImagePage가 세팅되어있다.
				
				if (_currentImagePage < _maxImagePage) {
					_currentImagePage++;
					NSURLRequest *req	= [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:_imageURL, _currentImagePage]]];
					//				[[SecurityManager sharedSecurityManager] loadRequest:req];
					[_web loadRequest:req];
				}
			}
            
			
			
			
			break;
	}
	
	tabBar.selectedItem = nil;
}



#pragma mark -
#pragma mark SecurityManagerDelegate methods
#pragma mark -
- (void)returnResult:(NSString *)returnResult errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage {
	[AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
	_isTrSend = YES;
	if (errorCode == 0) {
        NSDictionary *docDic		= [returnResult JSONValue];
        NSString *transCode			= [docDic objectForKey:kTransCode];
        NSArray *arrResponses		= [docDic objectForKey:kTransResponseData];
        NSDictionary *dicResponse	= nil;
        NSString *actionCode		= nil;
        NSString *recvErrorCode		= nil;
        NSString *recvErrorMessage	= nil;
        NSString *retErrorMessage	= nil;
        
        if ([arrResponses count] > 0) {
            dicResponse		= [arrResponses objectAtIndex:0];
            actionCode			= [dicResponse objectForKey:kResponseErrorAction];
            recvErrorCode		= [dicResponse objectForKey:kResponseErrorCode];
            recvErrorMessage	= [dicResponse objectForKey:kResponseErrorMsg];
        }
        
        // action code 또는 return error code에 값이 있다면 오류이다.
        if (((actionCode != nil) && ([actionCode isEqualToString:@""] == NO)) || ((recvErrorCode != nil) && ([recvErrorCode isEqualToString:@""] == NO))) {

            
            // delegate를 통해 전달할 오류 메시지를 생성한다.
            if ([recvErrorCode isEqualToString:@"100"])
                retErrorMessage = recvErrorMessage;
            else
                retErrorMessage = [NSString stringWithFormat:@"통신상태가 원활하지 않습니다.\n오류코드 : %@\n오류메시지 : %@", recvErrorCode, recvErrorMessage];
            
//            [SysUtils showMessage:retErrorMessage];
            
            //error_action 처리로직
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:actionCode, kKeyOfErrorAction, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kExecuteErrorActionNotification object:nil userInfo:tempDic];
            
            return;
        }
        
        if ([recvErrorCode isEqualToString:@"0001"] || [recvErrorCode isEqualToString:@"1004"])
        {
            [AppUtils closeWaitingSplash];
            self.view.userInteractionEnabled = YES;
            [SessionManager sharedSessionManager].userID = @"";
            [SessionManager sharedSessionManager].sessionOutString = @"Y";
            [SessionManager sharedSessionManager].selectedCategoryID = @"";
            [SessionManager sharedSessionManager].categoryDataArr = nil;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutGo object:self userInfo:nil];

            return;
            
        }
        
        if ([transCode isEqualToString:@"CM0610"]) {
            _maxImagePage = [[dicResponse valueForKey:@"IMGMAXPAGE"] intValue];
            
            if (_maxImagePage <= 1) {
                // 더이상 이미지가 없다.
                return;
            } else {
                _currentImagePage++;
                NSURLRequest *req	= [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:_imageURL, _currentImagePage]]];
                [_web loadRequest:req];
            }
        }
		
	} else {
        if (errorCode == 1004) {
            return;
        }else{
            [SysUtils showMessage:errorMessage];
            
        }
    }
	
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType {
	if ([SysUtils isNull:aRequest] == YES || [SysUtils isNull:[aRequest URL]] == YES)
		return NO;
    
	NSString *URLString = [[aRequest URL] absoluteString];
	NSString *decoded = [URLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    
#if _DEBUG_
	NSLog(@"decoded : %@", decoded);
#endif
	
    
	NSString *URLScheme = [[aRequest URL] scheme];
    
    if ([URLScheme isEqualToString:@"iwebactioncb"] == YES || [URLScheme isEqualToString:@"iWebActionCB"] == YES){
        
        NSRange range;
        NSString *action;
        if ([URLScheme isEqualToString:@"iWebActionCB"]) {
            range = [decoded rangeOfString:@"iWebActionCB:"];
            action = [decoded substringFromIndex:range.location + 11];
            
        }else{
            range = [decoded rangeOfString:@"iwebactioncb:"];
            action = [decoded substringFromIndex:range.location + 13];
            
            
        }
        
		if ([SysUtils isNull:action] == NO) {
			NSDictionary *actionDic =  [action JSONValue];
			NSString *actionCode = [actionDic objectForKey:@"_action_code"];
            
            //go Home
            if ([actionCode isEqualToString:@"1002"]) {
                [SessionManager sharedSessionManager].userID = @"";
                [SessionManager sharedSessionManager].selectedCategoryID = @"";
                [SessionManager sharedSessionManager].categoryDataArr = nil;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            //logout
            if ([actionCode isEqualToString:@"5005"]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:ksesstionLogout object:self userInfo:nil];

            }
            //write
            if ([actionCode isEqualToString:@"4001"]) {
                [AppUtils settingRightButton:self action:@selector(writeNoticeAction:) normalImageCode:@"Top_write.png" highlightImageCode:@"Top_write.png"];

            }

            if ([actionCode isEqualToString:@"4002"]) {
                self.navigationItem.rightBarButtonItem = nil;

            }
            
            //save
            if ([actionCode isEqualToString:@"4003"]) {
                [AppUtils settingRightButton:self action:@selector(saveAction:) normalImageCode:@"Top_check.png" highlightImageCode:@"Top_check.png"];
                
            }

            //modify
            if ([actionCode isEqualToString:@"4004"]) {
                [AppUtils settingRightButton:self action:@selector(modifyAction:) normalImageCode:@"Top_write.png" highlightImageCode:@"Top_write.png"];
                
            }
            
            //delete
            if ([actionCode isEqualToString:@"4005"]) {
                [AppUtils settingRightButton:self action:@selector(deleteAction:) normalImageCode:@"Top_delete.png" highlightImageCode:@"Top_delete.png"];

            }
		}
	}else{
        
//        NSRange nRange;
//        nRange = [decoded rangeOfString:@"paction=create"];
//        if(nRange.location != NSNotFound){
//            ((UIButton *)[self.view viewWithTag:2002]).hidden = YES;
//            ((UIButton *)[self.view viewWithTag:2003]).hidden = YES;
//        }
//        
//        nRange = [decoded rangeOfString:@"paction=view"];
//        if(nRange.location != NSNotFound){
//            ((UIButton *)[self.view viewWithTag:2002]).hidden = YES;
//            ((UIButton *)[self.view viewWithTag:2003]).hidden = YES;
//        }
//        
//        nRange = [decoded rangeOfString:@"paction=download_attach"];
//        if(nRange.location != NSNotFound){
//            ((UIButton *)[self.view viewWithTag:2003]).hidden = NO;
//        }
//        
//        nRange = [decoded rangeOfString:@"paction=list"];
//        if(nRange.location != NSNotFound){
//            ((UIButton *)[self.view viewWithTag:2002]).hidden = NO;
//        }
        
    }
    
	return YES;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    
	_isAppBackAction = YES;
	_isLoading = NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    
    if ([urlFirstString length] > 0) {
        
    }else{
        urlFirstString = [[NSString alloc]initWithFormat:@"%@",webView.request.URL.absoluteString];
        
    }
    
    urlAllString = [[NSString alloc]initWithFormat:@"%@",webView.request.URL.absoluteString];
    
	if (!_isImageOpen) {
		self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	} else {
        // 2011.05.24 modify by leech : (수정요청사항). 2번째 페이지 전문통신후 부터 총 건수 표시하도록 수정 (첫페이지는 총건수 없음)
//        if ((_currentImagePage == 1) && (_isTrSend == NO)) {
//            
//            self.title = [NSString stringWithFormat:@"Page %d", _currentImagePage];  
//            
//        } else {
//            
//            self.title = [NSString stringWithFormat:@"Page %d/%d", _currentImagePage, _maxImagePage];
//            
//        }
        
        self.title = @"첨부파일";
        
	}
    
	_isLoading = NO;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [AppUtils showWaitingSplash];
    
	_isLoading = YES;
}

#pragma mark -
#pragma mark - navigationBar Button Event
#pragma mark -
- (void)deleteAction:(id)sender {
    [_web stringByEvaluatingJavaScriptFromString:@"fn_del();"];
    
}

- (void)modifyAction:(id)sender {
    [_web stringByEvaluatingJavaScriptFromString:@"fn_update();"];
    
}

- (void)saveAction:(id)sender {
    [_web stringByEvaluatingJavaScriptFromString:@"fn_save();"];

}

- (void)writeNoticeAction:(id)sender {
//
    [_web stringByEvaluatingJavaScriptFromString:@"fn_movePage();"];

}

- (void)leftButtonClicked:(UIButton *)sender {
	//만일 분기 처리가 있을 경우 Back 이나 다른 부분을 처리 하자. Back만있을 경우 함수 자체를 삭제 해도 무방.
    if ([_web canGoBack]) {
        [_web goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
