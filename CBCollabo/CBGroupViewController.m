//
//  CBGroupViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/8/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBGroupViewController.h"
#import "CBGroupViewCell.h"
#import "CBCreateViewController.h"
#import "CBMoreViewController.h"

@interface CBGroupViewController ()<CBCreateViewControllerDelegate,UIAlertViewDelegate>
{
    SpinnerView *spinnerView;
    NSMutableArray *resDataArray;
    UIView* coverView;
    NSString *_SENDIENCE_CNT;
    NSString *_RCVR_USER_ID;
    NSString *_RCVR_GB;
    NSString *_SRNO;
    NSString *message;
    int indextPathTag;
    int NEW_SENDIENCE_CNT;
    
}
@end

@implementation CBGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];
     [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_description_btn.png" highlightImageCode:@"op_description_btn_p.png"];
    
    // Send list group
    [self sendTransRequest:@"COLABO_L104"];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    spinnerView =[SpinnerView loadSpinnerIntoView:self.view];
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    [reqData setObject:userID forKey:@"USER_ID"];
    [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
    
    if ([tranCd isEqualToString:@"COLABO_D102"]) {
        [reqData setObject:_RCVR_USER_ID forKey:@"RCVR_USER_ID"];
        [reqData setObject:_RCVR_GB forKey:@"RCVR_GB"];
    }
    
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    [spinnerView removeSpinnerView]; // remove wating screen
    
    if ([transCode isEqualToString:@"COLABO_D102"]) {
        [resDataArray removeObjectAtIndex:indextPathTag];
         NEW_SENDIENCE_CNT = NEW_SENDIENCE_CNT-1;
        _SRNO = responseArray[0][@"COLABO_SRNO"];// get to use for reuse in more view controller
        
        // Set Title
        
        NSString *titleCountPerson = [NSString stringWithFormat:@"참여자(%d)",NEW_SENDIENCE_CNT];
        self.title = titleCountPerson;

        [self.delegate didUpdated]; // call method delegate
    }else{
        resDataArray = [[NSMutableArray alloc] initWithArray:responseArray[0][@"SENDIENCE_REC"]];
        _SENDIENCE_CNT = responseArray[0][@"SENDIENCE_CNT"];
        
        NEW_SENDIENCE_CNT = [_SENDIENCE_CNT intValue];
        
        _SRNO = responseArray[0][@"COLABO_SRNO"];// get to use for reuse in more view controller
        // Set Title
        //    _READ_USER_CNT = self.READ_USER_CNT;
        NSString *titleCountPerson = [NSString stringWithFormat:@"참여자(%@)",_SENDIENCE_CNT];
        self.title = titleCountPerson;
    }
    
  
    [self.tableView reloadData];
}

#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        _RCVR_USER_ID = resDataArray[indextPathTag][@"RCVR_USER_ID"];
        _RCVR_GB = resDataArray[indextPathTag][@"RCVR_GB"];
        [self sendTransRequest:@"COLABO_D102"];
    }
}

#pragma mark - Method
- (void)onDeleted:(UIButton *)indexPath{
    indextPathTag = indexPath.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"취소"
                                          otherButtonTitles:@"확인",nil];
    [alert show];
}

- (void)rightButtonClicked:(UIButton *)sender{
    
    UIImageView *toastImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"description_tip.png"]];
    toastImage.frame = CGRectMake(182, 0, 138, 89);
    toastImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    // duration in seconds
    int duration = 2;
    
    [self.view addSubview:toastImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toastImage removeFromSuperview];
    });
}


- (void)onOutSide:(UIButton *)indexPath{
    
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CBGroupViewCell *cell = (CBGroupViewCell *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBGroupViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([resDataArray[indexPath.row][@"RCVR_USER_ID"] isEqualToString:[SessionManager sharedSessionManager].userID]) {
        
    }

    
    // Show image
    NSString *imageFile = resDataArray[indexPath.row][@"PRFL_PHTG"];
    if (![SysUtils isNull:imageFile]) {
        NSURL *urlImage = [[NSURL alloc] initWithString:resDataArray[indexPath.row][@"PRFL_PHTG"]];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(q, ^{
            // Fetch the image from the server... /
            NSData *data = [NSData dataWithContentsOfURL:urlImage];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                //make rounded image
                cell.CBGPersonIcon.layer.cornerRadius = cell.CBGPersonIcon.frame.size.height /2;
                cell.CBGPersonIcon.layer.masksToBounds = YES;
                cell.CBGPersonIcon.layer.borderWidth = 0;
                cell.CBGPersonIcon.image =img;
            });
        });
        
    }
    
    // Set Name
    cell.CBGPersonName.text = resDataArray[indexPath.row][@"RCVR_USER_NM"];
    
    // Set company and department
    NSString *companyName = resDataArray[indexPath.row][@"RCVR_CORP_NM"];
    NSString *departmentName = resDataArray[indexPath.row][@"RCVR_DVSN_NM"];
    
    if ([SysUtils isNull:departmentName]) {
        cell.CBGPersonCompany.text = companyName;
    }else{
        cell.CBGPersonCompany.text = [NSString stringWithFormat:@"%@ | %@",companyName,departmentName];
    }
   
    NSString *sendingType = resDataArray[indexPath.row][@"SENDIENCE_GB"];
    NSString *recUserID = resDataArray[indexPath.row][@"RCVR_USER_ID"];
    
    if ([[SessionManager sharedSessionManager].userID isEqualToString:self.USER_ID]){
        if ([sendingType isEqualToString:@"1"]) {
            cell.CBGButtonOut.hidden = NO;
            cell.CBGButtonOut.layer.cornerRadius = 5.0f;
            [cell.CBGButtonOut setTitle:@"내보내기" forState:UIControlStateNormal];
            cell.CBGButtonOut.tag = indexPath.row;
            message = @"정말 내보내시겠습니까?";
            [cell.CBGButtonOut addTarget:self action:@selector(onDeleted:) forControlEvents:UIControlEventTouchDown];
        }else{
             cell.CBGButtonOut.hidden = YES;
        }
    }else{
         if ([sendingType isEqualToString:@"1"]) {
             if ([[SessionManager sharedSessionManager].userID isEqualToString:recUserID]) {
                 cell.CBGButtonOut.hidden = NO;
                 cell.CBGButtonOut.layer.cornerRadius = 5.0f;
                 [cell.CBGButtonOut setTitle:@"나가기" forState:UIControlStateNormal];
                 cell.CBGButtonOut.tag = indexPath.row;
                 message = @"정말 나가기를 하시겠습니까?";
                 [cell.CBGButtonOut addTarget:self action:@selector(onDeleted:) forControlEvents:UIControlEventTouchDown];
             }else{
                 cell.CBGButtonOut.hidden = YES;
             }
         }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Create Transparent Backgroud
    //create a new view with the same size
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,362)];
    // change the background color to black and the opacity to 0.6
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    // add this new view to your main view
    [self.view addSubview:coverView];
    
    CBGroupViewCell *cell = (CBGroupViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.CBPopupView.hidden = NO;
    
    // Set image
    self.CBPopPersonIcon.layer.cornerRadius = self.CBPopPersonIcon.frame.size.height /2;
    self.CBPopPersonIcon.layer.masksToBounds = YES;
    self.CBPopPersonIcon.layer.borderWidth = 0;
    self.CBPopPersonIcon.image =cell.CBGPersonIcon.image;
    
    // Set name, phone, telephone, mail
    self.CBPopPersonName.text = resDataArray[indexPath.row][@"RCVR_USER_NM"];
    self.CBPopPersonPhone.text = [SysUtils getHyphenPhonNumber:resDataArray[indexPath.row][@"CLPH_NO"]];
    self.CBPopPersonTelephone.text = [SysUtils getHyphenPhonNumber:resDataArray[indexPath.row][@"EXNM_NO"]];
    self.CBPopPersonMail.text = resDataArray[indexPath.row][@"EML"];
    
    // Set company and department
    NSString *companyName = resDataArray[indexPath.row][@"RCVR_CORP_NM"];
    NSString *departmentName = resDataArray[indexPath.row][@"RCVR_DVSN_NM"];
    
    if ([SysUtils isNull:departmentName]) {
        self.CBPopPersonCompany.text = companyName;
    }else{
        self.CBPopPersonCompany.text = [NSString stringWithFormat:@"%@ | %@",companyName,departmentName];
    }

}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CBCreateViewController class]]){
        CBCreateViewController *createView= segue.destinationViewController;
        createView.COLABO_SRNO = self.COLABO_SRNO;
        createView.delegate = self;
    }else if ([segue.destinationViewController isKindOfClass:[CBMoreViewController class]]){
        CBMoreViewController *moreView= segue.destinationViewController;
        moreView.COLABO_SRNO = _SRNO;
    }
}

#pragma mark - Method Delegate

- (void)addFinished{
    // Call back when click on 다음
    NSLog(@"Add Finished!");
    [self sendTransRequest:@"COLABO_L104"];
}

#pragma mark - Button IB

- (IBAction)onClosePopupPress:(UIButton *)sender {
    self.CBPopupView.hidden = YES;
    [coverView removeFromSuperview];// remove backgroud transparent
}
- (IBAction)onAddGroupButtonPress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"SegueCBCreateView" sender:nil];
}
@end
