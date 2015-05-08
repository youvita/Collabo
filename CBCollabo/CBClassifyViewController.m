//
//  CBClassifyViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/13/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBClassifyViewController.h"
#import "CBClassifyViewCell.h"
#import "CBCustomAlert.h"
#import "ToastView.h"

@interface CBClassifyViewController ()<UIAlertViewDelegate>
{
    SpinnerView *spinnerView;
    NSMutableArray *resDataArray;
    NSMutableArray *arrFolderData;
    NSString *COLABO_FLD_NAME;
    NSString *COLABO_FLD_SRNO;
    BOOL isEdit;
    BOOL isUpdateFolder;
}
@end

@implementation CBClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    arrFolderData = [[NSMutableArray alloc] init];
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];
    
    self.title = @"분류하기";
    [self sendTransRequest:@"COLABO_FLD_L101"];
    isUpdateFolder = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonClicked:(UIButton *)sender{
    if (arrFolderData.count !=0) {
        if (isUpdateFolder == YES) {
            [self sendTransRequest:@"COLABO_C103"]; // update when check box
        }else{
            [self.navigationController popViewControllerAnimated:YES]; // call back when has not update check box
        }
    }else{
        if (isUpdateFolder == YES) {
            // call back
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    spinnerView =[SpinnerView loadSpinnerIntoView:self.view];
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    [reqData setObject:userID forKey:@"USER_ID"];
    
    if ([tranCd isEqualToString:@"COLABO_FLD_L101"]) {
        [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
        
    }else if ([tranCd isEqualToString:@"COLABO_FLD_U101"]){
        [reqData setObject:COLABO_FLD_SRNO forKey:@"COLABO_FLD_SRNO"];
        [reqData setObject:COLABO_FLD_NAME forKey:@"COLABO_FLD_NM"];
        
    }else if ([tranCd isEqualToString:@"COLABO_C103"]){
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<arrFolderData.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSIndexPath *index = [arrFolderData objectAtIndex:i];
            NSLog(@"%ld",(long)index.row);
            [dic setObject:resDataArray[index.row][@"COLABO_FLD_SRNO"]forKey:@"COLABO_FLD_SRNO"];
            [tempArr addObject:dic];
        }
        
        [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
        [reqData setObject:tempArr forKey:@"COLABO_FLD_REC"];
    }
    else{
        [reqData setObject:COLABO_FLD_NAME forKey:@"COLABO_FLD_NM"];
    }
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    [spinnerView removeSpinnerView]; // remove wating screen
    
    resDataArray = [[NSMutableArray alloc] initWithArray:responseArray[0][@"COLABO_FLD_REC"]];
    
    // Check for short array
    if ([transCode isEqualToString:@"COLABO_FLD_C101"] || [transCode isEqualToString:@"COLABO_FLD_U101"]) {
        for (int i=0; i<resDataArray.count; i++) {
            if ([resDataArray[i][@"COLABO_FLD_SRNO"] isEqualToString:@"I"]) {
                [resDataArray replaceObjectAtIndex:0 withObject:resDataArray[i]]; // replace object array i to index 0
                [resDataArray removeObjectAtIndex:i]; // remove object array i
            }
        }
    }

    // respond create and update
    if ([transCode isEqualToString:@"COLABO_FLD_C101"]) {
        [self displayToastWithMessage:@"새로운 분류함이 생성되었습니다."];
        
    }else if ([transCode isEqualToString:@"COLABO_FLD_U101"]){
        [self displayToastWithMessage:@"분류함 이름이 변경되었습니다."];
        
    }else if ([transCode isEqualToString:@"COLABO_C103"]){
        // call back
        [self.navigationController popViewControllerAnimated:YES];
    }
        // Set empty folder bg
    if (resDataArray.count == 0) {
        self.CBNoneFolderBg.hidden = NO;
    }else{
        self.CBNoneFolderBg.hidden = YES;
    }
 
    [self.tableView reloadData];
    
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CBClassifyViewCell *cell = (CBClassifyViewCell *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBClassifyViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (resDataArray.count !=0) {
        cell.CBClassifyFolderName.text = resDataArray[indexPath.row][@"COLABO_FLD_NM"];
       
        
        NSString *fldSrno = resDataArray[indexPath.row][@"COLABO_FLD_SRNO"];
        // to hide first row
        if ([fldSrno isEqualToString:@"I"]) {
            cell.CBClassifyEditButton.hidden = YES;
        }else{
            cell.CBClassifyEditButton.hidden = NO;
        }
        
        cell.CBClassifyEditButton.tag = indexPath.row;
        [cell.CBClassifyEditButton addTarget:self action:@selector(onEditFolder:) forControlEvents:UIControlEventTouchDown];
        
        cell.CBClassifyCheckBox.tag = indexPath.row;
        [cell.CBClassifyCheckBox addTarget:self action:@selector(onCheckBox:) forControlEvents:UIControlEventTouchDown];
        cell.CBClassifyCheckBox.selected = [arrFolderData containsObject:indexPath];
        
        if ([resDataArray[indexPath.row][@"COLABO_CRPD_YN"] isEqualToString:@"Y"]) {
            cell.CBClassifyCheckBox.selected = YES;
            [arrFolderData addObject:indexPath];// add old folder
            isUpdateFolder = NO;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",resDataArray[indexPath.row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

#pragma mark - Method

- (void)onCheckBox:(UIButton *)sender{
    CBClassifyViewCell *cell = (CBClassifyViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    isUpdateFolder = YES;
    if (sender.selected == YES) {
        [sender setSelected:NO];
        [arrFolderData removeObject:indexPath];
    }else{
        [sender setSelected:YES];
        [arrFolderData addObject:indexPath];
    }
    
    NSLog(@"%@",arrFolderData);
  
}

- (void)onEditFolder:(UIButton *)indexPath{
    isEdit = YES;
    NSString *fldName = resDataArray[indexPath.tag][@"COLABO_FLD_NM"];
    COLABO_FLD_SRNO = resDataArray[indexPath.tag][@"COLABO_FLD_SRNO"];
    
    UIAlertView *alertViewFolder = [[UIAlertView alloc] initWithTitle:@"분류함 이름변경"
                                                              message:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"취소"
                                                    otherButtonTitles:@"저장", nil];
    alertViewFolder.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *myTextField = [alertViewFolder textFieldAtIndex:0];
    [alertViewFolder setTag:555];
    myTextField.text = fldName;
    myTextField.keyboardType=UIKeyboardTypeAlphabet;
    
    [alertViewFolder show];

}

-(void)displayToastWithMessage:(NSString *)toastMessage
{
    ToastView *toast = [[ToastView alloc] initWithFrameAndMessage:CGRectMake(([[UIScreen mainScreen] bounds].size.width - 300.0f) / 2, [[UIScreen mainScreen] bounds].size.height - 64.0f - 75.0f - 55.0f, 300.0f, 55.0f)
                                                          message:toastMessage];
    [self.view addSubview:toast];
    
    [toast start];
    
}


- (IBAction)onCreateFolderButtonPress:(UIButton *)sender {
    isEdit = NO;
    UIAlertView *alertViewFolder = [[UIAlertView alloc] initWithTitle:@"새 분류함 만들기"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"취소"
                                               otherButtonTitles:@"만들기", nil];
    alertViewFolder.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *myTextField = [alertViewFolder textFieldAtIndex:0];
    [alertViewFolder setTag:555];
    myTextField.keyboardType=UIKeyboardTypeAlphabet;
    
    [alertViewFolder show];
    
//    CBCustomAlert *alert = [[CBCustomAlert alloc] initWithTitle:@"Warning" message:@"Set background color:" delegate:self cancelButtonTitle:@"Gray" otherButtonTitle:@"White"];
//    [alert showInView:self.view];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != 0) {
        COLABO_FLD_NAME = [alertView textFieldAtIndex:0].text;
        
        if (isEdit == YES) {
            [self sendTransRequest:@"COLABO_FLD_U101"]; // Edited Folder
        }else{
            [self sendTransRequest:@"COLABO_FLD_C101"]; // Create Folder
        }
    }
}
@end
