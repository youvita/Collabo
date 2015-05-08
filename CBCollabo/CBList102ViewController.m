//
//  CBList102ViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/24/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBList102ViewController.h"
#import "CBMoreViewController.h"
#import "CBCreateViewController.h"
#import "CBClassifyViewController.h"
#import "CBLeftMenuViewController.h"
#import "SlideNavigationController.h"
#import "CustomCell.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "AllUtils.h"
#import "SpinnerView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface CBList102ViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>{
    NSMutableArray *resDataArray;
    UIView *writeView;
    UIView *searchView;
    CGFloat yOffset;
    SpinnerView *spinnerView;
    int pageNo;
    UIImageView *listImgBg;
    NSString *_COLABO_SRNO;
    NSString *_SENDIENCE_GB;
   
}
@property (nonatomic, strong)NSArray *imageNames;
@property (nonatomic, strong)NSMutableArray *images;
@end

@implementation CBList102ViewController

#pragma mark - Form Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [SlideNavigationController sharedInstance].portraitSlideOffset = 120;
    
    yOffset = 0.0;
    writeView = (UIView *)[self.view viewWithTag:103];
    searchView = (UIView *)[self.view viewWithTag:104];
    
    [SlideNavigationController sharedInstance].portraitSlideOffset = 120;
    
    resDataArray = [[NSMutableArray alloc] init];
    pageNo = 1;
    
    
    UIImage *listbg = [UIImage imageNamed:@"list_none.png"];
    listImgBg = [[UIImageView alloc] initWithFrame:CGRectMake(70, 100, 180, 220)];
    [listImgBg setImage:listbg];
    [self.tableView addSubview:listImgBg];
    
    // Adding top logo image
    UIImage *img = [UIImage imageNamed:@"top_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    [imgView setImage:img];
    // SetContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    
    // Remove line in table view
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addPullToRefreshHeader];
}

- (void)viewWillAppear:(BOOL)animated{
   spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    // request list
    [self sendTransRequest:@"COLABO_L102"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - SlideNavigationController Methods
//
//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
//    
//    return YES;
//}


#pragma mark - TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
        if (cell == nil) {
    
    //        [tableView registerNib:[UINib nibWithNibName:@"SampleTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:IdentifierCell];
    //        cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    
            // or
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
    if (resDataArray.count !=0) {
    
    cell.CBlistTitle.text = resDataArray[indexPath.row][@"TTL"]; // title
    cell.CBlistSubTitle.text = resDataArray[indexPath.row][@"RGSR_NM"]; // sub title
    
    // Show file image
    NSString *atchCnt = resDataArray[indexPath.row][@"ATCH_CNT"];
    if (![atchCnt isEqualToString:@"0"]) {
        cell.CBAtchFile.hidden = NO;
    }
    
    // Date and time
    NSDate *stringDate = [SysUtils stringToDate:resDataArray[indexPath.row][@"RGSR_DTTM"] dateFormat:@"yyyyMMddHHmmss"];
    NSString *newDate = [NSString stringWithFormat:@"%@",stringDate];
   
    if (stringDate !=nil) {
        // Split string
        NSArray *items = [newDate componentsSeparatedByString:@" "];
        NSString *alarmDate = [items objectAtIndex:0];
        NSString *alarmTime = [items objectAtIndex:1];
        cell.CBlistDateTime.text = [NSString stringWithFormat:@"%@ | %@",alarmDate,[alarmTime substringWithRange:NSMakeRange(0,5)]];// date and time

    }
    
    NSString *sendingType = resDataArray[indexPath.row][@"SENDIENCE_GB"];
    NSString *commNewCnt = resDataArray[indexPath.row][@"COMMT_NEW_CNT"];
    NSString *isYN = resDataArray[indexPath.row][@"NEW_COLABO_YN"];
    
    // Number 1:receive and 3:send
    if ([sendingType isEqualToString:@"1"]) {
        cell.CBBgImage.image = [UIImage imageNamed:@"list_green_bg.png"];
        cell.CBlistImage.image = [UIImage imageNamed:@"list_receive_icon.png"];
    }else{
        cell.CBBgImage.image = [UIImage imageNamed:@"list_purple_bg.png"];
        cell.CBlistImage.image = [UIImage imageNamed:@"list_send_icon.png"];
    }
    
    // Show notice new symbol to cell
    if (![isYN isEqualToString:@"N"]) {
        cell.CBNoticeView.hidden = NO;
        cell.CBNoticeNumber.text = @"N";
    }
    
    // Show notice number of new symbol to cell
    if (![commNewCnt isEqualToString:@"0"]) {
        cell.CBNoticeView.hidden = NO;
        cell.CBNoticeNumber.text = commNewCnt;
    }
        
    if ([isYN isEqualToString:@"N"]) {
        cell.CBNoticeView.hidden = YES;
    }
//    if ([commNewCnt isEqualToString:@"0"]){
//        
//    }
    
    // Set backround color table view
    cell.backgroundColor = RGB(242,242,242);
        
    }

    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Select %@",resDataArray[indexPath.row]);
    
    
    _COLABO_SRNO = resDataArray[indexPath.row][@"COLABO_SRNO"];
    _SENDIENCE_GB = resDataArray[indexPath.row][@"SENDIENCE_GB"];
    [self performSegueWithIdentifier:@"CBSegueMoreView" sender:nil];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // A case was selected, so push into the CaseDetailViewController
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    // Change background image for cell
    if ([cell.CBBgImage.image isEqual:[UIImage imageNamed:@"list_green_bg.png"]]) {
        // Handle tap code here
        cell.CBBgImage.highlightedImage = [UIImage imageNamed:@"list_green_bg_p.png"];
        cell.CBBgImage.highlighted = YES;
    }else{
        cell.CBBgImage.highlightedImage = [UIImage imageNamed:@"list_purple_bg_p.png"];
        cell.CBBgImage.highlighted = YES;
    }

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Unhighlight Cell
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.CBBgImage.highlighted = NO;
  }

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Yes");
}


#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
   
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    [reqData setObject:userID forKey:@"USER_ID"];
    if ([tranCd isEqualToString:@"COLABO_ALAM_R101"]) {
        
    }else if([tranCd isEqualToString:@"COLABO_D101"]){
        [reqData setObject:_COLABO_SRNO forKey:@"COLABO_SRNO"];
    }
    else{
        [reqData setObject:@"" forKey:@"COLABO_FLD_SRNO"];
        [reqData setObject:@"15" forKey:@"PG_PER_CNT"];
        [reqData setObject:[NSString stringWithFormat:@"%i",pageNo] forKey:@"PG_NO"];
    }
   
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
   
    [listImgBg removeFromSuperview]; // remove none list background
     if ([transCode isEqualToString:@"COLABO_ALAM_R101"]) {
         // get alarm counter
         self.NoticeNum.text = responseArray[0][@"NEW_ALAM_CNT"];
         
         if (![self.NoticeNum.text isEqualToString:@"0"]) {
             self.NoticeBg.hidden = NO;
         }else{
             self.NoticeBg.hidden = YES;
         }
         
     }else if ([transCode isEqualToString:@"COLABO_D101"]){
        [self sendTransRequest:@"COLABO_L102"];
     }
     else{
         if (pageNo == 1) {
             NSArray *tempData = [[NSArray alloc] initWithArray:responseArray[0][@"COLABO_REC"]];
             for (int i =0; i<tempData.count; i++) {
                 [resDataArray insertObject:tempData[i] atIndex:i];
             }
             
         }else{
             // more data responding
             NSArray *tempData = [[NSArray alloc] initWithArray:responseArray[0][@"COLABO_REC"]];
             
             for (int i =0; i<tempData.count; i++) {
                 [resDataArray insertObject:tempData[i] atIndex:resDataArray.count];
             }
         }
         
         // request alarm count
         [self sendTransRequest:@"COLABO_ALAM_R101"];
         
     }
    
    CBLeftMenuViewController *leftMenuView = [[CBLeftMenuViewController alloc] init];
    [leftMenuView viewDidLoad];
    
    
    [self.tableView reloadData];
    [spinnerView removeSpinnerView]; // remove wating screen
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CBMoreViewController class]]){
        CBMoreViewController *moreView= segue.destinationViewController;
        moreView.COLABO_SRNO = _COLABO_SRNO;
        moreView.SENDIENCE_GB = _SENDIENCE_GB;
    }else if([segue.destinationViewController isKindOfClass:[CBClassifyViewController class]]){
        CBClassifyViewController *classifyView= segue.destinationViewController;
        classifyView.COLABO_SRNO = _COLABO_SRNO;
    }else if([segue.destinationViewController isKindOfClass:[CBCreateViewController class]]){
        CBCreateViewController *createView= segue.destinationViewController;
        createView.isCreateColabo = YES; // Create Collabo
    }
    
}


#pragma mark - Pull to refresh

- (void)addPullToRefreshHeader {
    _refreshHeaderView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - 45.0f, 320, 30.0f)];
    _refreshHeaderView.backgroundColor  = [UIColor clearColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    _refreshArrow                   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_01.png"]];
    _refreshArrow.frame             = CGRectMake((screenWidth/2)-10, 10.0f, 20, 20);
    
    
    self.imageNames = @[@"load_01.png",@"load_02.png",@"load_03.png",@"load_04.png",@"load_05.png",@"load_06.png"];
    _images=[[NSMutableArray alloc]init];
    for (int i=0; i<self.imageNames.count; i++) {
        [_images addObject:[UIImage imageNamed:[self.imageNames objectAtIndex:i]]];
    }
    
    _refreshArrow.animationImages = _images;
    _refreshArrow.animationDuration = 1.0;
    
    [_refreshHeaderView addSubview:_refreshArrow];
    
    [self.tableView addSubview:_refreshHeaderView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
    
    // fade in and fade out button
    if (scrollView.contentOffset.y == 0.00 || scrollView.contentOffset.y <= 0.30) {
    } else if (scrollView.contentOffset.y < yOffset) {
        // scrolls down.
        yOffset = scrollView.contentOffset.y;
        [UIView animateWithDuration:0.8 animations:^{
            writeView.alpha = 1;
            searchView.alpha = 1;
            self.onTopSearchView.constant = 0;
        }];
        
    } else
    {
        // scrolls up.
        yOffset = scrollView.contentOffset.y;
        [UIView animateWithDuration:0.8 animations:^{
            writeView.alpha = 0;
            searchView.alpha = 0;
            self.onTopSearchView.constant = -40;
        }];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView.contentOffset.y<-25){
        _refreshArrow.image = [UIImage imageNamed:@"load_01.png"];
    }
    if(scrollView.contentOffset.y<-30){
        _refreshArrow.image  = [UIImage imageNamed:@"load_02.png"];
    }
    if(scrollView.contentOffset.y<-35){
        _refreshArrow.image  = [UIImage imageNamed:@"load_03.png"];
    }
    if(scrollView.contentOffset.y<-40){
        _refreshArrow.image  = [UIImage imageNamed:@"load_04.png"];
    }
    if(scrollView.contentOffset.y<-45){
        _refreshArrow.image  = [UIImage imageNamed:@"load_05.png"];
    }
    if(scrollView.contentOffset.y<-50){
        _refreshArrow.image  = [UIImage imageNamed:@"load_06.png"];
    }
    if(scrollView.contentOffset.y<-55){
        _refreshArrow.image  = [UIImage imageNamed:@"load_01.png"];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}
- (void)startLoading {
    isLoading = YES;
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset       = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        [_refreshArrow startAnimating];
    }];
    // Refresh action!
    [self refresh];
}
- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    pageNo ++;
    [self sendTransRequest:@"COLABO_L102"];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}
-(void)stopLoadingComplete {
    // Reset the header
    _refreshArrow.hidden = NO;
    [_refreshArrow stopAnimating];
    //    [self prepareDataWithTranCode:@"crmc_cust_list_r001.jct"];
}

#pragma mark - Button IB

- (IBAction)onAlarmButtonPress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"SegueCBAlarmList101" sender:nil];

}

- (IBAction)onSearchButtonPress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"SegueSearch" sender:nil];
}

- (IBAction)onSlideButtonPress:(UIButton *)sender {
//    SlideNavigationController *slide = [[SlideNavigationController alloc] init];
//    [slide openMenu:1 withCompletion:nil];
}

- (IBAction)onCreateButtonPress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"SegueCBCreateView" sender:nil];
}

- (IBAction)onMoreMenuButtonPress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"SegueCBSingupView" sender:nil];
}

- (IBAction)onLongPressButtonCell:(UILongPressGestureRecognizer *)sender {
    NSString *leave = @"나가기";
    NSString *hide = @"숨기기";
    NSString *classify = @"분류하기";
    NSString *delete = @"삭제";
    
    CGPoint currentPoint = [sender locationInView:self.tableView];
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:currentPoint];
    _SENDIENCE_GB = resDataArray[index.row][@"SENDIENCE_GB"];
     _COLABO_SRNO = resDataArray[index.row][@"COLABO_SRNO"];
    NSLog(@"%@",_SENDIENCE_GB);

    if (sender.state == UIGestureRecognizerStateEnded) {
                UIActionSheet *popup;
        if ([_SENDIENCE_GB isEqualToString:@"3"]){
            popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:
                     leave,
                     hide,
                     classify,
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

}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:{
                        NSLog(@"To Leave");
                        UIAlertView *alert;
                        // Can not 나가기 because is not 나가기
                        if ([_SENDIENCE_GB isEqualToString:@"3"]) {
                            alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                           message:@"콜리보 작성자는 나가기를 하실 수 없습니다."
                                                          delegate:self
                                                        cancelButtonTitle:@"확인"
                                                    otherButtonTitles:nil];
 
                        }else{
                            alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                            message:@"정말 나가기를 하시겠습니까?"
                                                        delegate:self
                                                    cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인",nil];
                        }
                            [alert show];
                    }
                    break;
                case 1:
                    NSLog(@"To Hide");
                    break;
                case 2:
                    NSLog(@"To Classify");
                    [self performSegueWithIdentifier:@"SegueCBClassifyView" sender:nil];
                    break;
                case 3:{
                        NSLog(@"To Delete");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                                    message:@"정말 삭제 하시겠습니까?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"취소"
                                                          otherButtonTitles:@"확인",nil];
                        [alert show];
                    
                    }
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

#pragma UIAlerView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        [self deleteComfirm];
    }
}

- (void)deleteComfirm{
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [self sendTransRequest:@"COLABO_D101"];
}



@end
