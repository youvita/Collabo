//
//  CBAlarmList101.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/27/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBAlarmList101ViewController.h"
#import "CBMoreViewController.h"
#import "CBCustomAlarmCell.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "SpinnerView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface CBAlarmList101ViewController (){
    NSMutableArray *resDataArray;
    SpinnerView *spinnerView;
    UIImageView *listImgBg;
    int pageNo;
    NSString *_COLABO_SRNO;
}

@end

@implementation CBAlarmList101ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];
    
    self.navigationItem.hidesBackButton = YES;
    self.title = @"알림";
    
    resDataArray = [[NSMutableArray alloc] init];
    pageNo = 1;
    
    UIImage *listbg = [UIImage imageNamed:@"none_alarm.png"];
    listImgBg = [[UIImageView alloc] initWithFrame:CGRectMake(50, 130, 203, 132)];
    [listImgBg setImage:listbg];
    [self.tableView addSubview:listImgBg];
    
    // request list
    [self sendTransRequest:@"COLABO_ALAM_L101"];
    
    [self addPullToRefreshHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    
    [reqData setObject:userID forKey:@"USER_ID"];
    [reqData setObject:@"15" forKey:@"PG_PER_CNT"];
    [reqData setObject:[NSString stringWithFormat:@"%i",pageNo] forKey:@"PG_NO"];
   
    
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    
        [listImgBg removeFromSuperview];
        if (pageNo == 1) {
            NSArray *tempData = [[NSArray alloc] initWithArray:responseArray[0][@"COLABO_ALAM_REC"]];
            for (int i =0; i<tempData.count; i++) {
                [resDataArray insertObject:tempData[i] atIndex:i];
            }
            
        }else{
            // more data responding
            NSArray *tempData = [[NSArray alloc] initWithArray:responseArray[0][@"COLABO_ALAM_REC"]];
            
            for (int i =0; i<tempData.count; i++) {
                [resDataArray insertObject:tempData[i] atIndex:resDataArray.count];
            }
        }
    
    [self.tableView reloadData];
    [spinnerView removeSpinnerView]; // remove wating screen
    
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CBCustomAlarmCell *cell =(CBCustomAlarmCell *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBCustomAlarmCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.CBAlarmTitle.text = resDataArray[indexPath.row][@"RGSR_ID"];
    cell.CBAlarmSubTitle.text = resDataArray[indexPath.row][@"RGSR_NM"];
    NSDate *stringDate = [SysUtils stringToDate:resDataArray[indexPath.row][@"RGSR_DTTM"] dateFormat:@"yyyyMMddHHmmss"];
    NSString *newDate = [NSString stringWithFormat:@"%@",stringDate];
    cell.CBAlarmDateTime.text = [newDate substringWithRange:NSMakeRange(0,16)];
   
    
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
                cell.CBAlarmPerson.layer.cornerRadius = cell.CBAlarmPerson.frame.size.height /2;
                cell.CBAlarmPerson.layer.masksToBounds = YES;
                cell.CBAlarmPerson.layer.borderWidth = 0;
                cell.CBAlarmPerson.image =img;
            });
        });
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _COLABO_SRNO = resDataArray[indexPath.row][@"COLABO_SRNO"];
    [self performSegueWithIdentifier:@"CBSegueMoreView" sender:nil];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CBMoreViewController class]]){
        CBMoreViewController *moreView= segue.destinationViewController;
        moreView.COLABO_SRNO = _COLABO_SRNO;
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
    
    
    NSArray *imageNames = @[@"load_01.png",@"load_02.png",@"load_03.png",@"load_04.png",@"load_05.png",@"load_06.png"];
    NSMutableArray *images=[[NSMutableArray alloc]init];
    for (int i=0; i<imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    _refreshArrow.animationImages = images;
    _refreshArrow.animationDuration = 1.0;
    
    [_refreshHeaderView addSubview:_refreshArrow];
    
    [self.tableView addSubview:_refreshHeaderView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
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
    [self sendTransRequest:@"COLABO_ALAM_L101"];
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
}

@end
