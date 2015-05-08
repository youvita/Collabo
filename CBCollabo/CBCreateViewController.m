//
//  CBCreateViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/2/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBCreateViewController.h"
#import "CBCreateViewCell.h"
#import "CBGroupViewController.h"
#import "CBCreateCollaboViewController.h"

#define kKeyXOffset 60

@interface CBCreateViewController (){
    UIButton *TabRecentButton;
    UIButton *TabPhoneButton;
    UIButton *TabPeopleButton;
    UIButton *TabContactButton;
    SpinnerView *spinnerView;
    NSArray *respDataArray;
    NSMutableArray *resDataTemp;
    NSMutableArray *personArray;
    NSMutableArray *personDeleteArray;
    NSMutableArray *viewArray;
    NSMutableDictionary *temp;
    UIView *personView;
    int xOffset;
    int personTagCount;
    NSString *_COLABO_SRNO;
    
    NSMutableSet *SENSet;

}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSearchViewConstraint;


@end

@implementation CBCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    xOffset = 18; // defult x poin
    
    TabRecentButton = (UIButton*)[self.view viewWithTag:1];
    TabPhoneButton = (UIButton*)[self.view viewWithTag:2];
    TabPeopleButton = (UIButton*)[self.view viewWithTag:3];
    TabContactButton = (UIButton*)[self.view viewWithTag:4];
    
    personArray = [[NSMutableArray alloc] init];
    personDeleteArray = [[NSMutableArray alloc] init];
    viewArray = [[NSMutableArray alloc] init];
   
    self.CBScrollViewListDelete.backgroundColor = [UIColor whiteColor];
    
    // Set check defult tab
    TabRecentButton.selected = YES;
    self.CBTabRecentLine.backgroundColor = RGB(105, 100, 210);
//    self.CBContentViewController = [[UIView alloc ]initWithFrame:CGRectMake(0, 100, 320, 502)];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_cancel_btn.png" highlightImageCode:@"top_cancel_btn_p.png"];
    
    [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_next_btn.png" highlightImageCode:@"top_next_btn_p.png"];
    
    self.title = @"참여자 선택 (최근)";
    
    [self sendTransRequest:@"COLABO_SNDCE_L101"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CBCreateViewCell *cell = (CBCreateViewCell *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBCreateViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.CBPersonCheckbox.image = [UIImage imageNamed:@"checkbox_default.png"];
    cell.CBPersonName.text = respDataArray[indexPath.row][@"RCVR_NM"];
    
    NSString *imageFile = respDataArray[indexPath.row][@"PRFL_PHTG"];
    if (![SysUtils isNull:imageFile]) {
        NSURL *urlImage = [[NSURL alloc] initWithString:respDataArray[indexPath.row][@"PRFL_PHTG"]];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(q, ^{
            // Fetch the image from the server... /
            NSData *data = [NSData dataWithContentsOfURL:urlImage];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                //make rounded image
                cell.CBPersonImage.layer.cornerRadius = cell.CBPersonImage.frame.size.height /2;
                cell.CBPersonImage.layer.masksToBounds = YES;
                cell.CBPersonImage.layer.borderWidth = 0;
                cell.CBPersonImage.image =img;
            });
        });
    }
    
    // Show line on top only
    if (indexPath.row != 0) {
        cell.CBLineTop.hidden = YES;
    }

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return respDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBCreateViewCell *cell = (CBCreateViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    // Check box condition
    if ([cell.CBPersonCheckbox.image isEqual:[UIImage imageNamed:@"checkbox_default.png"]]) {
        cell.CBPersonCheckbox.image = [UIImage imageNamed:@"checkbox_select.png"];
        [personArray addObject:resDataTemp[indexPath.row]];
        
    }else{
        cell.CBPersonCheckbox.image = [UIImage imageNamed:@"checkbox_default.png"];
        [personArray removeObject:[resDataTemp objectAtIndex:indexPath.row]];
        
        UIView *view = (UIView *)[personView viewWithTag:indexPath.row];
        [view removeFromSuperview];
        
        
        
        xOffset = xOffset - kKeyXOffset;
        NSLog(@"%@",personArray);
    }
   
//    // Count for show delete person
    if (personArray.count > 0) {
        
        //////////////////////////////// below is to move your view by constant////////////////////////////////
        // 104 = your scrollView Hieght
        self.verticalSearchViewConstraint.constant = 104;
        ////////////////////////////////////////////////////////////////////////////
        self.CBScrollViewListDelete.backgroundColor = RGB(242, 242, 242);


        if ([cell.CBPersonCheckbox.image isEqual:[UIImage imageNamed:@"checkbox_select.png"]]) {
//            personTagCount +=1;
//            int currentView;
//            NSString *rView = [NSString stringWithFormat:@"View%d",currentView];
            
            personView = [[UIView alloc ] initWithFrame:CGRectMake(xOffset, 0, 50, 90)];
            UIImageView *personImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_icon.png"]];
            personImage.frame = CGRectMake(5, 16, 41, 41);
            personImage.layer.cornerRadius = personImage.frame.size.height /2;
            personImage.layer.masksToBounds = YES;
            personImage.layer.borderWidth = 0;
            personImage.image = cell.CBPersonImage.image;
            [personView addSubview:personImage];
            
            UIImage* imgNormal					= [UIImage imageNamed:@"img_del_btn.png"];
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 8, 18, 18)];
            [deleteButton setBackgroundImage:imgNormal forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(onDeletePerson) forControlEvents:UIControlEventTouchDown];
            [personView addSubview:deleteButton];
            
            UILabel *personName = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 50, 20)];
            personName.text = cell.CBPersonName.text;
            personName.textColor = RGB(80, 80, 80);
            personName.textAlignment = NSTextAlignmentCenter;
            [personName setFont:[UIFont fontWithName: @"Helvetica" size: 15.0f]];
            
            [personView addSubview:personName];
            personView.tag = indexPath.row;
            
//            [viewArray addObject:personView];
            
            NSLog(@"%@",personView);
            [personDeleteArray addObject:personView];
            [self.CBScrollViewListDelete addSubview:personView];
            
            xOffset = xOffset + kKeyXOffset;
 
//            if (xOffset > 320) {
//               self.CBScrollViewListDelete.frame = CGRectMake(0, 60, 640, 104);
//                NSLog(@"%@",self.CBScrollViewListDelete);
//            }
           
        }
        
        // show
//         NSLog(@"// add %d",personArray.count);
        //        self.CBScrollViewListDelete.frame = CGRectMake(0, 0, 320, 90);
        
        
    }else{
        
//         NSLog(@"// remove %d",personArray.count);
        ////////////set constant to 0 when user unselected//////////////////////////////////
        self.verticalSearchViewConstraint.constant = 0;
        ////////////////////////////////////////////////////////////////////////////////////
        self.CBScrollViewListDelete.backgroundColor = [UIColor whiteColor];
    }
    
     NSLog(@"%@",SENSet);
}



#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    
    if ([tranCd isEqualToString:@"COLABO_C104"]) {
        [reqData setObject:userID forKey:@"USER_ID"];
        [reqData setObject:self.COLABO_SRNO forKey:@"COLABO_SRNO"];
        [reqData setObject:resDataTemp forKey:@"SENDIENCE_REC"];
    }else{
        [reqData setObject:userID forKey:@"USER_ID"];
    }
    
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CBGroupViewController class]]){
        CBGroupViewController *groupView= segue.destinationViewController;
        groupView.COLABO_SRNO = _COLABO_SRNO;
    }else if([segue.destinationViewController isKindOfClass:[CBCreateCollaboViewController class]]){
        CBCreateCollaboViewController *createCollaboView= segue.destinationViewController;
        createCollaboView.resDataTemp = personArray;
    }
}


- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    [spinnerView removeSpinnerView]; // remove wating screen
    if ([transCode isEqualToString:@"COLABO_C104"]) {
        [self.delegate addFinished];
        _COLABO_SRNO = responseArray[0][@"COLABO_SRNO"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        respDataArray = [[NSArray alloc] initWithArray:responseArray[0][@"SENDIENCE_REC"]];
        
        resDataTemp = [[NSMutableArray alloc] init];
        for (int i=0; i<respDataArray.count; i++) {
            NSMutableDictionary *resData = [[NSMutableDictionary alloc] init];
            [resData setObject:respDataArray[i][@"RCVR_ID"] forKey:@"RCVR_ID"];
            [resData setObject:respDataArray[i][@"RCVR_NM"] forKey:@"RCVR_NM"];
            [resData setObject:respDataArray[i][@"RCVR_GB"] forKey:@"RCVR_GB"];
            [resDataTemp addObject:resData];
        }
        
        [self.tableView reloadData];
    }
    
}

#pragma mark - Method
- (void)rightButtonClicked:(UIButton *)sender{
    if (self.isCreateColabo == YES) {
        // go to create
        if (personArray.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                            message:@"선택된 참여자가 없습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                            otherButtonTitles:nil];
            [alert show];

        }else{
           [self performSegueWithIdentifier:@"SegueCBCreateCollaboView" sender:nil];
        }
        

    }else{
        [self sendTransRequest:@"COLABO_C104"];
    }
}

-(void)onDeletePerson{
    NSLog(@"Deleted");
}

#pragma mark- Button IB
- (IBAction)CBScrollViewListDeleteButtonPress:(UIButton *)sender {
    
}

- (IBAction)CBTabGroupButtonPress:(UIButton *)sender {
    
    switch (sender.tag) {
        // Tab Recent
        case 1:
            TabRecentButton.selected = YES;
            TabPhoneButton.selected = NO;
            TabPeopleButton.selected = NO;
            TabContactButton.selected = NO;
            self.CBTabRecentLine.backgroundColor = RGB(105, 100, 210);
            self.CBTabPhoneLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabPeopleLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabContactLine.backgroundColor = RGB(200, 200, 200);
            break;
        
        // Tab Phone
        case 2:
            TabRecentButton.selected = NO;
            TabPhoneButton.selected = YES;
            TabPeopleButton.selected = NO;
            TabContactButton.selected = NO;
            self.CBTabPhoneLine.backgroundColor = RGB(105, 100, 210);
            self.CBTabRecentLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabPeopleLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabContactLine.backgroundColor = RGB(200, 200, 200);
            break;
            
        // Tab People
        case 3:
            TabRecentButton.selected = NO;
            TabPhoneButton.selected = NO;
            TabPeopleButton.selected = YES;
            TabContactButton.selected = NO;
            self.CBTabPeopleLine.backgroundColor = RGB(105, 100, 210);
            self.CBTabRecentLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabPhoneLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabContactLine.backgroundColor = RGB(200, 200, 200);

            break;
            
        // Tab Contact
        case 4:
            TabRecentButton.selected = NO;
            TabPhoneButton.selected = NO;
            TabPeopleButton.selected = NO;
            TabContactButton.selected = YES;
            self.CBTabContactLine.backgroundColor = RGB(105, 100, 210);
            self.CBTabRecentLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabPhoneLine.backgroundColor = RGB(200, 200, 200);
            self.CBTabPeopleLine.backgroundColor = RGB(200, 200, 200);

            break;
    }
}
@end
