//
//  CBMoreViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/6/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBMoreViewController.h"
#import "CBMoreViewCell.h"
#import "CBGroupViewController.h"
#import "CBWriteCommViewController.h"
#import "CBClassifyViewController.h"
#import "CBCreateCollaboViewController.h"

@interface CBMoreViewController () <UIAlertViewDelegate,CBGroupViewControllerDelegate,CBWriteCommViewControllerDelegate,CBCreateCollaboViewControllerDelegate,UIActionSheetDelegate>
{
    SpinnerView *spinnerView;
    NSArray         *resDataArray;
    NSArray         *atchRec;
    NSMutableArray  *resCommDataArray;
    NSMutableArray  *arrDataModify;
    NSMutableArray  *arrDataUpdateCollabo;
    NSString        *_COLABO_SRNO;
    NSString        *READ_USER_CNT;
    NSString        *USER_ID;
    NSString        *isMode;
    UIImageView     *lineTopTableView;
    UIWebView       *webView;
    UIView          *viewFileDownload;
    UIScrollView    *myScrollView;
    UIView          *mainView;
    UIView          *viewProfile;
    UIView          *viewMore;
    UIImageView     *line;
    
    int hieght;
    int yOffset;
    int indextPathTag;
    BOOL setModifyType;
    CGFloat yOffsetScroll;
    CGFloat viewMoreHeight;
    int kKeyFoldOffset;
}

@end

@implementation CBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    yOffsetScroll = 0.0;
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];
    
    [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_more_btn.png" highlightImageCode:@"top_more_btn_p.png"];
    
    self.title = @"상세조회";
    [self sendTransRequest:@"COLABO_R103"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    spinnerView =[SpinnerView loadSpinnerIntoView:self.view];
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    
    if ([tranCd isEqualToString:@"COLABO_R103"]) {
        [reqData setObject:userID forKey:@"USER_ID"];
        [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];

    }else{
        [reqData setObject:userID forKey:@"USER_ID"];
        [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
        [reqData setObject:@"" forKey:@"PG_PER_CNT"];
        [reqData setObject:@"" forKey:@"PG_NO"];
    }
    
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
     [spinnerView removeSpinnerView]; // remove wating screen
    
    if ([transCode isEqualToString:@"COLABO_COMMT_D101"]) {
        // Delete data in list

        NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
        
        [reqData setObject:userID forKey:@"USER_ID"];
        [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
        [reqData setObject:@"" forKey:@"PG_PER_CNT"];
        [reqData setObject:@"" forKey:@"PG_NO"];
      
        [super sendTransaction:@"COLABO_R104" requestDictionary:reqData];
       
    }else{
        resDataArray = [[NSArray alloc] initWithArray:responseArray];
        if ([transCode isEqualToString:@"COLABO_R103"]) {
            atchRec = [[NSArray alloc] initWithArray:resDataArray[0][@"ATCH_REC"]];
            
            USER_ID =  resDataArray[0][@"RGSR_ID"];
            // saving seril to use in read more people
            _COLABO_SRNO = resDataArray[0][@"COLABO_SRNO"];
            isMode = resDataArray[0][@"W_MODE"];
            
            // Update collabo
            NSMutableDictionary *dicUpdateData = [[NSMutableDictionary alloc] init];
            arrDataUpdateCollabo = [[NSMutableArray alloc] init];
            
            [dicUpdateData setObject:resDataArray[0][@"COLABO_SRNO"] forKey:@"COLABO_SRNO"];
            [dicUpdateData setObject:resDataArray[0][@"TTL"] forKey:@"TTL"];
            [dicUpdateData setObject:resDataArray[0][@"CNTN"]forKey:@"CNTN"];
            [dicUpdateData setObject:resDataArray[0][@"ATCH_REC"] forKey:@"ATCH_REC"];
            [arrDataUpdateCollabo addObject:dicUpdateData];
            
            /////////////////////////////////////////////////////////////////////////////////////////////
            
            mainView = [[UIView alloc] init];
            viewMore = [[UIView alloc] init];
            viewProfile = [[UIView alloc] init];
            // Set view profile
           
            viewProfile.frame = CGRectMake(0, 0, 320, 127);
            
            // Set title profile
            UILabel *titleProfile = [[UILabel alloc] init];
            titleProfile.frame = CGRectMake(12, 20, 275, 21);
            titleProfile.textColor = RGB(80, 80, 165);
            titleProfile.font = [UIFont fontWithName: @"Helvetica" size: 17.0f];
            titleProfile.textAlignment = NSTextAlignmentCenter;
            [viewProfile addSubview:titleProfile];
            
            // Set button fold up and down
            UIImage *imageFoldNormal        = [UIImage imageNamed:@"unfold_btn.png"];
            UIButton *imageButtonFold       = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButtonFold.frame           = CGRectMake(286, 20, 25, 25);
            [imageButtonFold setBackgroundImage:imageFoldNormal forState:UIControlStateNormal];
            
            UIImage *imageFoldSeleted        = [UIImage imageNamed:@"fold_btn.png"];
            [imageButtonFold setBackgroundImage:imageFoldSeleted forState:UIControlStateSelected];
            
            [imageButtonFold addTarget:self action:@selector(onFoldButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewProfile addSubview:imageButtonFold];
            
            // Set image profile
            UIImageView *imageProfile    = [[UIImageView alloc] init];
            imageProfile.frame = CGRectMake(12, 64, 41, 41);
            [viewProfile addSubview:imageProfile];
            
            // Set name profile
            UILabel *nameProfile = [[UILabel alloc] init];
            nameProfile.frame = CGRectMake(12, 20, 275, 21);
            nameProfile.textColor = RGB(80, 80, 80);
            nameProfile.font = [UIFont fontWithName: @"Helvetica" size: 13.0f];
            nameProfile.textAlignment = NSTextAlignmentLeft;
            [viewProfile addSubview:nameProfile];
            
            // Set department profile
            UILabel *departProfile = [[UILabel alloc] init];
            departProfile.frame = CGRectMake(12, 20, 275, 21);
            departProfile.textColor = RGB(150, 150, 150);
            departProfile.font = [UIFont fontWithName: @"Helvetica" size: 11.0f];
            departProfile.textAlignment = NSTextAlignmentLeft;
            [viewProfile addSubview:departProfile];
            
            // Set date and time profile
            UILabel *dtProfile = [[UILabel alloc] init];
            dtProfile.frame = CGRectMake(61, 84, 174, 21);
            dtProfile.textColor = RGB(150, 150, 150);
            dtProfile.font = [UIFont fontWithName: @"Helvetica" size: 11.0f];
            dtProfile.textAlignment = NSTextAlignmentLeft;
            [viewProfile addSubview:dtProfile];
            
            // Set file icon
            UIImageView *fileIcon    = [[UIImageView alloc] init];
            fileIcon.frame = CGRectMake(171, 88, 7, 13);
            fileIcon.image = [UIImage imageNamed:@"file_icon.png"];
            fileIcon.hidden = YES;
            [viewProfile addSubview:imageProfile];
            
            // Set button more people
            UIImage *imagePeopleNormal        = [UIImage imageNamed:@"people.png"];
            UIButton *imageButtonPeople       = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButtonPeople.frame           = CGRectMake(255, 72, 56, 25);
            [imageButtonPeople setBackgroundImage:imagePeopleNormal forState:UIControlStateNormal];
            [imageButtonPeople addTarget:self action:@selector(onMorePeopleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewProfile addSubview:imageButtonPeople];
            
            // Set number of people
            UILabel *numberPeople = [[UILabel alloc] init];
            numberPeople.frame = CGRectMake(281, 74, 57, 21);
            numberPeople.textColor = RGB(105, 100, 210);
            numberPeople.font = [UIFont fontWithName: @"Helvetica" size: 12.0f];
            numberPeople.textAlignment = NSTextAlignmentLeft;
            [viewProfile addSubview:numberPeople];

            // Set line
            line    = [[UIImageView alloc] init];
            line.frame = CGRectMake(0, 126, 320, 1);
            line.backgroundColor = RGB(105, 100, 210);
            [viewProfile addSubview:line];


            titleProfile.text = resDataArray[0][@"TTL"];
            
            
            NSString *imageFile = resDataArray[0][@"PRFL_PHTG"];
            if (![SysUtils isNull:imageFile]) {
                NSURL *urlImage = [[NSURL alloc] initWithString:resDataArray[0][@"PRFL_PHTG"]];
                
                dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                dispatch_async(q, ^{
                    // Fetch the image from the server... /
                    NSData *data = [NSData dataWithContentsOfURL:urlImage];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        /* This is the main thread again, where we set the tableView's image to
                         be what we just fetched. */
                        //make rounded image
                        imageProfile.layer.cornerRadius = imageProfile.frame.size.height /2;
                        imageProfile.layer.masksToBounds = YES;
                        imageProfile.layer.borderWidth = 0;
                        imageProfile.image =img;
                    });
                });
                
            }else{
                imageProfile.image = [UIImage imageNamed:@"person_icon.png"];
            }
            
            // Date and time
            NSDate *stringDate = [SysUtils stringToDate:resDataArray[0][@"RGSN_DTTM"] dateFormat:@"yyyyMMddHHmmss"];
            NSString *newDate = [NSString stringWithFormat:@"%@",stringDate];
            
            // Split string
            NSArray *items = [newDate componentsSeparatedByString:@" "];
            NSString *Date = [items objectAtIndex:0];
            NSString *Time = [items objectAtIndex:1];
            dtProfile.text = [NSString stringWithFormat:@"%@ | %@ | ",Date,[Time substringWithRange:NSMakeRange(0,5)]];// date and time
            

            // Count user
            READ_USER_CNT = resDataArray[0][@"SENDIENCE_CNT"];
            numberPeople.text  = [NSString stringWithFormat:@"%@명",READ_USER_CNT];

            if (atchRec.count !=0) {
                fileIcon.hidden = NO;
            }
            
            NSString *name = resDataArray[0][@"RGSR_NM"];
            // Fix size label
            CGSize maximumLabelSize = CGSizeMake(236,21);
            CGSize expectedLabelSize = [name sizeWithFont:[UIFont systemFontOfSize:13]
                                        constrainedToSize:maximumLabelSize];
            
            nameProfile.frame = CGRectMake(61, 64,expectedLabelSize.width+70,21);
            nameProfile.text = name;
            departProfile.frame = CGRectMake(expectedLabelSize.width+70, 64,140,21);
            departProfile.text = resDataArray[0][@"RGSR_CORP_NM"];
            
            viewProfile.backgroundColor = RGB(242, 242, 242);
            [mainView addSubview:viewProfile];
            mainView.frame = CGRectMake(0, 0, 320, viewProfile.frame.size.height);
            self.tableView.tableHeaderView = mainView;
            
           /////////////////////////////////////////////////////////////////////////////////////////////
            
            
            // Set Content view
            NSString *cnt = resDataArray[0][@"CNTN"];
            // Fix size label
            CGFloat heightContent = [SysUtils measureTextHeight:cnt fontName:@"Helvetica" fontSize:15 constrainedToSize:CGSizeMake(236,21)];
   
            CGFloat poinY = 0;
            CGFloat poinX = 0;
            
            if (atchRec.count !=0) {
                viewFileDownload = [[UIView alloc] init];
                myScrollView = [[UIScrollView alloc]initWithFrame:
                                CGRectMake(8, 12, 304, 127)];
                
                for (int i=0; i<atchRec.count; i++) {
                    if ([isMode isEqualToString:@"M"]) {
                        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                        dispatch_async(q, ^{
                            // Fetch the image from the server... /
                            // Set image source
                            NSURL *urlImage = [[NSURL alloc] initWithString:atchRec[i][@"ATCH_URL"]];
                            NSData *data = [NSData dataWithContentsOfURL:urlImage];
                            UIImage *image = [[UIImage alloc] initWithData:data];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                /* This is the main thread again, where we set the tableView's image to
                                 be what we just fetched. */
                                UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
                                imgView.frame = CGRectMake(poinX, 0,304, 127);
                                
                                [myScrollView addSubview:imgView];
                                
                                myScrollView.pagingEnabled = YES;
                                myScrollView.showsHorizontalScrollIndicator = NO;
                                myScrollView.showsVerticalScrollIndicator = NO;
                                myScrollView.backgroundColor = RGB(220, 220, 220);
                                myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width * atchRec.count,
                                                                      imgView.frame.size.height);

                            });
                        });
                    
                        poinX = poinX + 304;
                        
                    }else{
                      
                        UIImage* imgNormal = [UIImage imageNamed:@"download_btn.png"];
                        UIButton *downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(8, poinY, 304, 44)];
                        [downloadButton setBackgroundImage:imgNormal forState:UIControlStateNormal];
                        
                        UIImage* aHighlightImageCode = [UIImage imageNamed:@"download_btn_p.png"];
                        [downloadButton setBackgroundImage:aHighlightImageCode forState:UIControlStateHighlighted];
                        
                        [downloadButton addTarget:self action:@selector(onDownloading) forControlEvents:UIControlEventTouchDown];
                        
                        NSString *stringFileName = atchRec[i][@"FILE_NAME"];
                        NSString *nameFileDownload;
                        CGFloat width =  [stringFileName sizeWithFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]].width;
                        
                        // Condition for the file name that length is long
                        if (width>200) {
                            NSString *firstStringFileName = [stringFileName substringWithRange:NSMakeRange(0,stringFileName.length/2)];
                            NSString *lastStringFileName = [stringFileName substringFromIndex:[stringFileName length]-6];
                            NSString *fullStringFileName = [NSString stringWithFormat:@"%@...%@",firstStringFileName,lastStringFileName];
                            nameFileDownload = fullStringFileName;
                        }else{
                            nameFileDownload = stringFileName;
                        }
                        
                        // File Name
                        UILabel *nameFile = [[UILabel alloc] initWithFrame:CGRectMake(50, 10,width, 20)];
                        nameFile.text = nameFileDownload;
                        nameFile.textColor = RGB(110, 110, 110);
                        nameFile.textAlignment = NSTextAlignmentLeft;
                        [nameFile setFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]];
                        [downloadButton addSubview:nameFile];
                        
                        // File Size
                        UILabel *sizeFile = [[UILabel alloc] init];
                        sizeFile.text = [SysUtils transformedValue:atchRec[i][@"FILE_SIZE"]];
                        sizeFile.frame = CGRectMake(220, 10,70, 20);
                        sizeFile.textColor = RGB(180, 180, 180);
                        sizeFile.textAlignment = NSTextAlignmentRight;
                        [sizeFile setFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]];
                        [downloadButton addSubview:sizeFile];
                        
                        NSLog(@"%@",[SysUtils transformedValue:atchRec[i][@"FILE_SIZE"]]);
                        [viewFileDownload addSubview:downloadButton];
                        
                        poinY = poinY + 50;

                    }
                }// End for loop
                
                // Check for add more view in profile view header
                if ([isMode isEqualToString:@"M"]) {
                    [viewMore addSubview:myScrollView];
                    // Add webview
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 127, 320, heightContent*2)];
                    [webView loadHTMLString:resDataArray[0][@"CNTN"] baseURL:nil];
                    [viewMore addSubview:webView];
                    
                    viewMoreHeight = myScrollView.frame.size.height + webView.frame.size.height;
                    
                }else{
                    
                    // Add webview
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, heightContent*2)];
                    [webView loadHTMLString:resDataArray[0][@"CNTN"] baseURL:nil];
                    [viewMore addSubview:webView];
                    
                    viewFileDownload.frame = CGRectMake(0, webView.frame.size.height+webView.frame.origin.y, 320, poinY);
                    [viewMore addSubview:viewFileDownload];
                    
                    viewMoreHeight = viewFileDownload.frame.size.height + webView.frame.size.height;
                }
                
            }else{
                // Check when have only content
                if (![SysUtils isNull:cnt]) {
                    // Add webview
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, heightContent*2)];
                    [webView loadHTMLString:cnt baseURL:nil];
                    [viewMore addSubview:webView];
                    
                    viewMoreHeight = webView.frame.size.height;

                }
            }
            
            viewMore.frame = CGRectMake(0, 127, 320,viewMoreHeight);
            
            // Send request list detail
            [self sendTransRequest:@"COLABO_R104"];
            
        }else{
            resCommDataArray = [[NSMutableArray alloc] initWithArray:resDataArray[0][@"COMMT_REC"]];
            [self.tableView reloadData];
        }
    }
   
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        [self deleteComfirm];
    }
}

- (void)deleteComfirm{
    spinnerView =[SpinnerView loadSpinnerIntoView:self.view];
    
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    
    [reqData setObject:userID forKey:@"USER_ID"];
    [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
    [reqData setObject:[resCommDataArray objectAtIndex:indextPathTag][@"COLABO_COMMT_SRNO"] forKey:@"COLABO_COMMT_SRNO"];
    
    [super sendTransaction:@"COLABO_COMMT_D101" requestDictionary:reqData];
    
    NSLog(@"%@",[resCommDataArray objectAtIndex:indextPathTag][@"COLABO_COMMT_SRNO"]);
}

- (void)onModify:(UIButton *)indexPath{
    arrDataModify = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    
    [dicData setObject:resCommDataArray[indexPath.tag][@"COLABO_COMMT_SRNO"] forKey:@"COLABO_COMMT_SRNO"];
    [dicData setObject:resCommDataArray[indexPath.tag][@"CNTN"] forKey:@"CNTN"];
    [dicData setObject:resCommDataArray[indexPath.tag][@"ATCH_REC"] forKey:@"ATCH_REC"];
    [dicData setObject:resCommDataArray[indexPath.tag][@"IMG_ATCH_REC"] forKey:@"IMG_ATCH_REC"];
    
    [arrDataModify addObject:dicData];
    setModifyType = YES;
    [self performSegueWithIdentifier:@"SegueCBWriteCommView" sender:nil];
}

- (void)onDeleted:(UIButton *)indexPath{
    indextPathTag = indexPath.tag;
    NSLog(@"%d",indextPathTag);

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                    message:@"정말 삭제 하시겠습니까?"
                                                   delegate:self
                                          cancelButtonTitle:@"취소"
                                          otherButtonTitles:@"확인",nil];
    [alert show];
}

#pragma mark - Scroll View Delegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    // fade in and fade out button
//    if (self.tableView.frame.size.height>self.view.frame.size.height) {
//        if (scrollView.contentOffset.y == 0.00 || scrollView.contentOffset.y <= 0.30) {
//        } else if (scrollView.contentOffset.y < yOffsetScroll) {
//            // scrolls down.
//            yOffsetScroll = scrollView.contentOffset.y;
//            [UIView animateWithDuration:0.8 animations:^{
//                self.CBReplyButton.alpha = 1;
//            }];
//        } else
//        {
//            // scrolls up.
//            yOffsetScroll = scrollView.contentOffset.y;
//            [UIView animateWithDuration:0.8 animations:^{
//                self.CBReplyButton.alpha = 0;
//                
//            }];
//        }
// 
//    }
//    
//}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%d",resCommDataArray.count);
    return resCommDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CBMoreViewCell *cell = (CBMoreViewCell *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBMoreViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    for(UIView *v in [cell subviews])
    {
        if([v isKindOfClass:[UIButton class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UIImageView class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UILabel class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UIScrollView class]]){
            [v removeFromSuperview];
        }
    }
    // Set defult button to hide
    cell.CBButtonDelete.hidden = YES;
    cell.CBButtonEdit.hidden = YES;
    
    if (resCommDataArray.count !=0) {
    
    if ([resCommDataArray[indexPath.row][@"RGSR_ID"] isEqualToString:[SessionManager sharedSessionManager].userID]) {
        
        // Set button Delete
        cell.CBButtonDelete.hidden = NO;
        cell.CBButtonDelete.tag = indexPath.row;
        [cell.CBButtonDelete addTarget:self action:@selector(onDeleted:) forControlEvents:UIControlEventTouchDown];
        
        // Set button Edit
        cell.CBButtonEdit.hidden = NO;
        cell.CBButtonEdit.tag = indexPath.row;
        [cell.CBButtonEdit addTarget:self action:@selector(onModify:) forControlEvents:UIControlEventTouchDown];

    }
    
    // Set defult image icon
    cell.CBPersonIcon.image = [UIImage imageNamed:@"person_icon.png"];
    
   // Show image
    NSString *imageFile = resCommDataArray[indexPath.row][@"PRFL_PHTG"];
    if (![SysUtils isNull:imageFile]) {
        NSURL *urlImage = [[NSURL alloc] initWithString:resCommDataArray[indexPath.row][@"PRFL_PHTG"]];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(q, ^{
            // Fetch the image from the server... /
            NSData *data = [NSData dataWithContentsOfURL:urlImage];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                //make rounded image
                cell.CBPersonIcon.layer.cornerRadius = cell.CBPersonIcon.frame.size.height /2;
                cell.CBPersonIcon.layer.masksToBounds = YES;
                cell.CBPersonIcon.layer.borderWidth = 0;
                cell.CBPersonIcon.image =img;
            });
        });
        
    }
    
    // Date and time
    NSDate *stringDate = [SysUtils stringToDate:resCommDataArray[indexPath.row][@"RGSR_DTTM"] dateFormat:@"yyyyMMddHHmmss"];
    NSString *newDate = [NSString stringWithFormat:@"%@",stringDate];
    
    // Split string
    NSArray *items = [newDate componentsSeparatedByString:@" "];
    NSString *Date = [items objectAtIndex:0];
    NSString *Time = [items objectAtIndex:1];
    cell.CBPersonDateTime.text = [NSString stringWithFormat:@"%@ | %@",Date,[Time substringWithRange:NSMakeRange(0,5)]];// date and time

    
    // Set Name and Company
    NSString *name = resCommDataArray[indexPath.row][@"RGSR_NM"];
    
    // Fix size label
    CGFloat width =  [name sizeWithFont:[UIFont fontWithName: @"Helvetica" size: 13.0f]].width;
   
    
    // Add person to cell
    UILabel *personName = [[UILabel alloc] initWithFrame:CGRectMake(62, 20,width, 21)];
    personName.text = name;
    personName.textColor = RGB(80, 80, 80);
    personName.textAlignment = NSTextAlignmentLeft;
    [personName setFont:[UIFont fontWithName: @"Helvetica" size: 13.0f]];
    [cell addSubview:personName];

    // Add company to cell
    UILabel *personCompany = [[UILabel alloc] initWithFrame:CGRectMake(personName.frame.size.width+70, 20,140, 21)];
    personCompany.text = resCommDataArray[indexPath.row][@"RGSR_CORP_NM"];
    personCompany.textColor = RGB(150, 150,150);
    personCompany.textAlignment = NSTextAlignmentLeft;
    [personCompany setFont:[UIFont fontWithName: @"Helvetica" size: 11.0f]];
    [cell addSubview:personCompany];

    cell.CBPersonContent.text = resCommDataArray[indexPath.row][@"CNTN"];
        
    yOffset = 100;// set y poin start download box
    CGFloat poinX = 0;
    

    NSArray *imageRec = [[NSArray alloc] initWithArray:resCommDataArray[indexPath.row][@"IMG_ATCH_REC"]];
        // Check file
        if (imageRec.count !=0) {
            // Remove view before add new view
            UIScrollView *cellScrollView = [[UIScrollView alloc]initWithFrame:
                                            CGRectMake(8, yOffset, 304, 127)];
            cellScrollView.backgroundColor = RGB(220, 220, 220);
            [self loadingWaitImage:cellScrollView isStart:YES];// start wating image loading

            for (int i =0; i<imageRec.count; i++) {
                
                dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                dispatch_async(q, ^{
                    // Fetch the image from the server... /
                    // Set image source
                    NSURL *urlImage = [[NSURL alloc] initWithString:imageRec[i][@"ATCH_URL"]];
                    NSData *data = [NSData dataWithContentsOfURL:urlImage];
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        /* This is the main thread again, where we set the tableView's image to
                         be what we just fetched. */
                        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
                        imgView.frame = CGRectMake(poinX, 0,304, 127);
                       
                        // The property scroll view in cell
                        cellScrollView.pagingEnabled = YES;
                        cellScrollView.showsHorizontalScrollIndicator = NO;
                        cellScrollView.showsVerticalScrollIndicator = NO;
                        cellScrollView.contentSize = CGSizeMake(cellScrollView.frame.size.width * imageRec.count,
                                                              imgView.frame.size.height);
                        [cellScrollView addSubview:imgView];
                        [self loadingWaitImage:cellScrollView isStart:NO]; // stop wating image loading
                    });
                });
                
                poinX = poinX + 304;
            }
            yOffset = 230;
            [cell addSubview:cellScrollView];
        }// end if image condition

    NSArray *atcRec = [[NSArray alloc] initWithArray:resCommDataArray[indexPath.row][@"ATCH_REC"]];
    
    // Check file
    if (atcRec.count !=0) {
        // Remove view before add new view
       
        for (int i =0; i<atcRec.count; i++) {
            
            UIImage* imgNormal = [UIImage imageNamed:@"download_btn.png"];
            UIButton *downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(8, yOffset, 304, 44)];
            [downloadButton setBackgroundImage:imgNormal forState:UIControlStateNormal];
            
            UIImage* aHighlightImageCode = [UIImage imageNamed:@"download_btn_p.png"];
            [downloadButton setBackgroundImage:aHighlightImageCode forState:UIControlStateHighlighted];
            
            [downloadButton addTarget:self action:@selector(onDownloading) forControlEvents:UIControlEventTouchDown];
            
            NSString *stringFileName = atcRec[i][@"FILE_NAME"];
            NSString *nameFileDownload;
            CGFloat width =  [stringFileName sizeWithFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]].width;
            
            // Condition for the file name that length is long
            if (width>200) {
                NSString *firstStringFileName = [stringFileName substringWithRange:NSMakeRange(0,stringFileName.length/2)];
                NSString *lastStringFileName = [stringFileName substringFromIndex:[stringFileName length]-6];
                NSString *fullStringFileName = [NSString stringWithFormat:@"%@...%@",firstStringFileName,lastStringFileName];
                nameFileDownload = fullStringFileName;
            }else{
                nameFileDownload = stringFileName;
            }
            
            // File Name
            UILabel *nameFile = [[UILabel alloc] initWithFrame:CGRectMake(50, 10,width, 20)];
            nameFile.text = nameFileDownload;
            nameFile.textColor = RGB(110, 110, 110);
            nameFile.textAlignment = NSTextAlignmentLeft;
            [nameFile setFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]];
            [downloadButton addSubview:nameFile];
            
            // File Size
            UILabel *sizeFile = [[UILabel alloc] init];
            sizeFile.text = [SysUtils transformedValue:atcRec[i][@"FILE_SIZE"]];
            sizeFile.frame = CGRectMake(220, 10,70, 20);
            sizeFile.textColor = RGB(180, 180, 180);
            sizeFile.textAlignment = NSTextAlignmentRight;
            [sizeFile setFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]];
            [downloadButton addSubview:sizeFile];
            
            NSLog(@"%@",[SysUtils transformedValue:atcRec[i][@"FILE_SIZE"]]);
            
            [cell addSubview:downloadButton];
            
            yOffset = yOffset + 50;

        }
        
    }else{
        if (imageRec.count == 0) {
           yOffset = (cell.CBPersonContent.frame.size.height+cell.CBPersonContent.frame.origin.y)+5;
        }
    }
        
}
    
    UIImageView *LineCell = [[UIImageView alloc] initWithFrame:CGRectMake(0, yOffset-1, 320, 1)];
    LineCell.backgroundColor = RGB(200, 200, 200);
    [cell addSubview:LineCell];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return yOffset;
}

- (void)onDownloading{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CBGroupViewController class]]){
        CBGroupViewController *groupView= segue.destinationViewController;
        groupView.COLABO_SRNO = _COLABO_SRNO;
        groupView.READ_USER_CNT = READ_USER_CNT;
        groupView.USER_ID = USER_ID;
        groupView.delegate = self;
    }else if ([segue.destinationViewController isKindOfClass:[CBWriteCommViewController class]]){
        CBWriteCommViewController *writeView= segue.destinationViewController;
        writeView.COLABO_SRNO = _COLABO_SRNO;
        writeView.delegate = self;
        writeView.arrDataModify = arrDataModify;
        writeView.isModify = setModifyType;// identify edit or write
    }else if([segue.destinationViewController isKindOfClass:[CBClassifyViewController class]]){
        CBClassifyViewController *classifyView= segue.destinationViewController;
        classifyView.COLABO_SRNO = _COLABO_SRNO;
    }else if([segue.destinationViewController isKindOfClass:[CBCreateCollaboViewController class]]){
        CBCreateCollaboViewController *createCollaboView= segue.destinationViewController;
        createCollaboView.arrDataUpdateCollabo = arrDataUpdateCollabo;
        createCollaboView.isUpdateColabo = YES;
        createCollaboView.delegate = self;
    }
}


#pragma mark - Button IB

- (IBAction)onReplyButtonPress:(UIButton *)sender {
    setModifyType = NO; // is not edit
    [self performSegueWithIdentifier:@"SegueCBWriteCommView" sender:nil];
}


#pragma mark - Method
- (void)onMorePeopleButtonClicked:(UIButton *)sender{
    [self performSegueWithIdentifier:@"SegueCBGroupView" sender:nil];
}

- (void)onFoldButtonClicked:(UIButton *)sender{
    
    if (sender.selected == YES) {
        [sender setSelected:NO]; // make unfold
        NSLog(@"Unfold");
        mainView.frame = CGRectMake(0, 0, 320, viewProfile.frame.size.height);
        [viewMore removeFromSuperview];
//        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = mainView;
        
        // set line move up
        line.frame = CGRectMake(0,126, 320, 1);
    }else{
        [sender setSelected:YES]; // make fold
        NSLog(@"fold");
        mainView.frame = CGRectMake(0, 0, 320, viewProfile.frame.size.height + viewMore.frame.size.height);
        [mainView addSubview:viewMore];
//        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = mainView;
        NSLog(@"%f",mainView.frame.size.height);
        // set line move down
        line.frame = CGRectMake(0,mainView.frame.size.height, 320, 1);

    }
        
  

}

- (void)rightButtonClicked:(UIButton *)sender{
    NSString *leave = @"나가기";
    NSString *hide = @"숨기기";
    NSString *classify = @"분류하기";
    NSString *update = @"수정";
    NSString *delete = @"삭제";
    UIActionSheet *popup;
    if ([self.SENDIENCE_GB isEqualToString:@"3"]){
        popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:
                                leave,
                                hide,
                                classify,
                                update,
                                delete,
                                nil];
           }else{
        popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:
                                leave,
                                hide,
                                classify,
                                nil];
    }
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}


//#pragma mark - Method Delegate
- (void)didSaveData{
     NSLog(@"did SaveData");
    [self sendTransRequest:@"COLABO_R103"];
}

- (void)didUpdated{
    NSLog(@"did Update");
    [self sendTransRequest:@"COLABO_R103"];
}

- (void)didUpdateCollabo{
    NSLog(@"did Update Collabo");
    [self sendTransRequest:@"COLABO_R103"];
 
}

-(void)displayToastWithMessage:(NSString *)toastMessage
{
    ToastView *toast = [[ToastView alloc] initWithFrameAndMessage:CGRectMake(([[UIScreen mainScreen] bounds].size.width - 300.0f) / 2, [[UIScreen mainScreen] bounds].size.height - 64.0f - 75.0f - 55.0f, 300.0f, 55.0f)
                                                          message:toastMessage];
    [self.view addSubview:toast];
    
    [toast start];

}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"To Leave");
                    break;
                case 1:
                    NSLog(@"To Hide");
                    break;
                case 2:
                    NSLog(@"To Classify");
                    [self performSegueWithIdentifier:@"SegueCBClassifyView" sender:nil];
                    break;
                case 3:{
                        NSLog(@"To Update");
                     if ([self.SENDIENCE_GB isEqualToString:@"3"]){
                         if ([isMode isEqualToString:@"P"]) {
                             [self displayToastWithMessage:@"PC에서 작성한 콜라보는 모바알에서 수정이 불가능합니다."];
                         }else{
                             [self performSegueWithIdentifier:@"SegueCBCreateCollaboView" sender:nil];
                             
                         }
                     }
                    }
                    break;
                case 4:
                    NSLog(@"To Delete");
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)loadingWaitImage:(UIScrollView*)superView isStart:(BOOL)start{
    NSArray *imageName = @[@"load_01.png",@"load_02.png",@"load_03.png",@"load_04.png",@"load_05.png",@"load_06.png"];
    UIImageView *animationLoad = [[UIImageView alloc] init];
    
    if (start == YES) {
        NSMutableArray *imageload = [[NSMutableArray alloc] init];
        for (int i = 0; i<imageName.count; i++) {
            [imageload addObject:[UIImage imageNamed:[imageName objectAtIndex:i]]];
        }
        animationLoad.frame = CGRectMake(140,50, 20, 20);
        animationLoad.animationImages = imageload;
        animationLoad.animationDuration = 1;
        [superView addSubview:animationLoad];
        [animationLoad startAnimating];

    }else{
        [animationLoad stopAnimating];
    }
}

@end
