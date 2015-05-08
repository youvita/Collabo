//
//  CBCreateViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/2/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBCreateViewController.h"
#import "CBCreateViewCell.h"

#define kKeyboarOffset 90

@interface CBCreateViewController (){
    UIButton *TabRecentButton;
    UIButton *TabPhoneButton;
    UIButton *TabPeopleButton;
    UIButton *TabContactButton;
    SpinnerView *spinnerView;
    NSArray *respDataArray;
    NSMutableArray *personArray;
    UIView *personView;

}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSearchViewConstraint;


@end

@implementation CBCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TabRecentButton = (UIButton*)[self.view viewWithTag:1];
    TabPhoneButton = (UIButton*)[self.view viewWithTag:2];
    TabPeopleButton = (UIButton*)[self.view viewWithTag:3];
    TabContactButton = (UIButton*)[self.view viewWithTag:4];
    
    personArray = [[NSMutableArray alloc] init];
    
    // Set check defult tab
    TabRecentButton.selected = YES;
    self.CBTabRecentLine.backgroundColor = RGB(105, 100, 210);
//    self.CBContentViewController = [[UIView alloc ]initWithFrame:CGRectMake(0, 100, 320, 502)];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_cancel_btn.png" highlightImageCode:@"top_cancel_btn_p.png"];
    
    [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_next_btn.png" highlightImageCode:@"top_next_btn_p.png"];
    
    self.title = @"참여자 선택 (최근)";
    
    [self sendTransRequest:@"COLABO_SNDCE_L101"];
}

- (void)rightButtonClicked:(UIButton *)sender{
    
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
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.CBPersonCheckbox.image = [UIImage imageNamed:@"checkbox_default.png"];
    cell.CBPersonName.text = respDataArray[indexPath.row][@"RCVR_ID"];
    
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
        [personArray addObject:respDataArray[indexPath.row]];
        cell.CBPersonCheckbox.image = [UIImage imageNamed:@"checkbox_select.png"];
        
//////////////////////////////// below is to move your view by constant////////////////////////////////
        // 104 = your scrollView Hieght
            self.verticalSearchViewConstraint.constant = 104;
        ////////////////////////////////////////////////////////////////////////////
    }else{
        cell.CBPersonCheckbox.image = [UIImage imageNamed:@"checkbox_default.png"];
        [personArray removeObject:[respDataArray objectAtIndex:indexPath.row]];
        
        ////////////set constant to 0 when user unselected//////////////////////////////////
            self.verticalSearchViewConstraint.constant = 0;
        ////////////////////////////////////////////////////////////////////////////////////
    }
   
//    // Count for show delete person
    if (personArray.count > 0) {
        
        CGRect rect = self.CBContentViewController.frame;
        rect.origin.y = 0;
        self.CBContentViewController.frame = rect;
        
        // show
         NSLog(@"// close%d",personArray.count);
        //        self.CBScrollViewListDelete.frame = CGRectMake(0, 0, 320, 90);
        
        personView = [[UIView alloc ] initWithFrame:CGRectMake(18, 0, 50, 90)];
        UIImageView *personImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_icon.png"]];
        personImage.frame = CGRectMake(5, 16, 41, 41);
        [personView addSubview:personImage];

        UILabel *personName = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 50, 20)];
        personName.text = cell.CBPersonName.text;
        personName.textColor = RGB(80, 80, 80);
        personName.textAlignment = NSTextAlignmentCenter;
        [personName setFont:[UIFont fontWithName: @"System" size: 15.0f]];
        [personView addSubview:personName];
        
        [self.CBScrollViewListDelete addSubview:personView];
     

//        self.CBScrollViewListDelete.hidden = NO;
    
       

      
        
    }else{
        
        CGRect rect = self.CBContentViewController.frame;
        rect.origin.y = -90;
        self.CBContentViewController.frame = rect;
        [personView removeFromSuperview];
      
//        self.CBScrollViewListDelete.hidden = YES;
        // close
        
        

    }
    
     NSLog(@"%@",NSStringFromCGRect(self.CBContentViewController.frame));
    
}



#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    [reqData setObject:userID forKey:@"USER_ID"];
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    
    respDataArray = [[NSArray alloc] initWithArray:responseArray[0][@"SENDIENCE_REC"]];
    [spinnerView removeSpinnerView]; // remove wating screen
    [self.tableView reloadData];
}




#pragma mark- Button Implement
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
