//
//  CBSearchList102ViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/30/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBSearchList102ViewController.h"
#import "CBMoreViewController.h"


@interface CBSearchList102ViewController ()<UISearchBarDelegate>{
    NSArray *resDataArray;
    NSArray *commRec;
    NSString *_COLABO_SRNO;
    SpinnerView *spinnerView;
    UIView *searchBg;
    UIView *bodyView;
    float heightYOffset;
    int yOffset;
    int totalRec;
}


@end

@implementation CBSearchList102ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    resDataArray = [[NSMutableArray alloc] init];

    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_back_btn.png" highlightImageCode:@"top_back_btn_p.png"];
    
    self.navigationItem.hidesBackButton = YES;
    self.title = @"검색";
    
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
        [reqData setObject:self.CBSearchBox.text forKey:@"SRCH_WORD"];
        [reqData setObject:@"15" forKey:@"PG_PER_CNT"];
        [reqData setObject:@"1" forKey:@"PG_NO"];
    
    
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    
    resDataArray = [[NSArray alloc] initWithArray:responseArray[0][@"COLABO_REC"]];
    
    NSString *TOT_CNT = responseArray[0][@"TOT_CNT"];
    totalRec = [TOT_CNT intValue];
    
    
    NSString *stringResult = [NSString stringWithFormat:@"'%@'",responseArray[0][@"SRCH_WORD"]];
    
    // Fix size label
    CGFloat width = [SysUtils measureTextWidth:stringResult fontName:@"Helvetica" fontSize:15 constrainedToSize:CGSizeMake(236,21)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    // Set Result Found
    UILabel *resultFound = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, width+70,21)];
    [resultFound setTextColor:RGB(105, 100, 210)];
    [resultFound setFont:[UIFont fontWithName: @"Helvetica" size: 15.0f]];
    resultFound.textAlignment = NSTextAlignmentLeft;
    resultFound.text = stringResult;
    [headerView addSubview:resultFound];
    
    // Set Result Count
    UILabel *resultCount = [[UILabel alloc] initWithFrame:CGRectMake(width+20, 20, 100,21)];
    [resultCount setTextColor:RGB(80, 80, 80)];
    [resultCount setFont:[UIFont fontWithName: @"Helvetica" size: 15.0f]];
    resultCount.textAlignment = NSTextAlignmentLeft;
    resultCount.text = [NSString stringWithFormat:@"검색결과 (%i)건",totalRec];
    [headerView addSubview:resultCount];
    
    // Set Line
    UIImageView *Line = [[UIImageView alloc] init];
    Line.frame = CGRectMake(0, 53, 320,1);
    Line.backgroundColor = RGB(105, 100, 210);
    [headerView addSubview:Line];
   
    
    if (totalRec == 0) {
        [bodyView removeFromSuperview];
        
        bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        
        // Set search image
        UIImageView *searchImage = [[UIImageView alloc] init];
        searchImage.frame = CGRectMake(86, 155, 149,149);
        searchImage.image = [UIImage imageNamed:@"search_bg_icon.png"];
        [bodyView addSubview:searchImage];

        
        // Set search text
        UILabel *searchText = [[UILabel alloc] initWithFrame:CGRectMake(0, 328, 320,21)];
        [searchText setTextColor:RGB(200, 200, 200)];
        [searchText setFont:[UIFont fontWithName: @"Helvetica" size: 14.0f]];
        searchText.textAlignment = NSTextAlignmentCenter;
        searchText.text = @"검색된 결과가 존재하지 않습니다.";
        [bodyView addSubview:searchText];
        
        // add searching not found to table view
        [self.tableView addSubview:bodyView];
        
    }else{
       
        // remove view searching not found
         [bodyView removeFromSuperview];
        
       
    }
    
    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData];
    [spinnerView removeSpinnerView]; // remove wating screen
    
}

#pragma mark - SeachBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark- TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierCell = @"Cell";
    CBCustomCellSearch *cell = (CBCustomCellSearch *)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBCustomCellSearch" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // reply comment
    for(UIView *v in [cell subviews])
    {
        if([v isKindOfClass:[UIButton class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UIImageView class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UILabel class]]){
            [v removeFromSuperview];
        }
    }

    
    if (resDataArray.count !=0) {
    
        UILabel *CBTitelRecive = (UILabel*)[cell viewWithTag:2];
        CBTitelRecive.text = resDataArray[indexPath.row][@"TTL"]; // title
    
        // Date and time
        UILabel *CBDateTimeRecive = (UILabel*)[cell viewWithTag:3];
        NSDate *stringDate = [SysUtils stringToDate:resDataArray[indexPath.row][@"RGSR_DTTM"] dateFormat:@"yyyyMMddHHmmss"];
        NSString *newDate = [NSString stringWithFormat:@"%@",stringDate];
        
        // Split string
        NSArray *items = [newDate componentsSeparatedByString:@" "];
        NSString *resDate = [items objectAtIndex:0];
        NSString *resTime = [items objectAtIndex:1];
        NSString *resName = resDataArray[indexPath.row][@"RGSR_NM"];

        CBDateTimeRecive.text = [NSString stringWithFormat:@"%@ | %@ | %@",resName,resDate,[resTime substringWithRange:NSMakeRange(0,5)]];// date and time
        
        NSString *sendingType = resDataArray[indexPath.row][@"SENDIENCE_GB"];
        UIImageView *CBImageType = (UIImageView*)[cell viewWithTag:1];
        
        // Number 1:receive and 3:send
        if ([sendingType isEqualToString:@"1"]) {
            CBImageType.highlighted = NO;
        }else{
            CBImageType.highlighted = YES;
        }

        yOffset = 50;
    
        commRec = [[NSArray alloc]initWithArray:resDataArray[indexPath.row][@"COMMT_REC"] ];

    if ([commRec count] !=0) {
        
            for (int i=0; i<[commRec count]; i++) {
                
                // Set View image
                UIImageView *replyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yOffset, 320,40)];
                
                // Set Image reply
                UIImage *image = [UIImage imageNamed:@"reply_icon.png"];
                UIImageView *replyImage = [[UIImageView alloc] initWithImage:image];
                replyImage.frame = CGRectMake(12, 15, 18,18);
                [replyView addSubview:replyImage];
                
                // Set Content
                UILabel *replyTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 255,40)];
                [replyTitle setTextColor:RGB(80, 80, 80)];
                [replyTitle setFont:[UIFont fontWithName: @"Helvetica" size: 13.0f]];
                replyTitle.textAlignment = NSTextAlignmentLeft;
                replyTitle.lineBreakMode = NSLineBreakByWordWrapping;
                replyTitle.numberOfLines = 2;
                replyTitle.text = commRec[i][@"COLABO_COMMT_CNTN"];
                [replyView addSubview:replyTitle];
                
                // Date and time
                NSDate *stringDate = [SysUtils stringToDate:commRec[i][@"COMMT_RGSR_DTTM"] dateFormat:@"yyyyMMddHHmmss"];
                NSString *newDate = [NSString stringWithFormat:@"%@",stringDate];
                
                // Split string
                NSArray *items = [newDate componentsSeparatedByString:@" "];
                NSString *Date = [items objectAtIndex:0];
                NSString *Time = [items objectAtIndex:1];
                
                NSString *userName = commRec[i][@"COMMT_RGSR_NM"];
                
                
                UILabel *replyDate = [[UILabel alloc] initWithFrame:CGRectMake(40, replyTitle.frame.size.height+8, 255,21)];
                [replyDate setTextColor:RGB(150, 150, 150)];
                [replyDate setFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]];
                replyDate.text = [NSString stringWithFormat:@"%@ | %@ | %@",userName,Date,[Time substringWithRange:NSMakeRange(0,5)]];// date and time
                [replyView addSubview:replyDate];
                
                [cell addSubview:replyView];
                
                yOffset = yOffset + 60;
            }
        
        }else{
            yOffset = 50;
        }
        
        // Set Line each row in table view
        UIImageView *LineCell = [[UIImageView alloc] initWithFrame:CGRectMake(0, yOffset+19, 320, 1)];
        LineCell.backgroundColor = RGB(200, 200, 200);
        [cell addSubview:LineCell];
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return yOffset+20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resDataArray.count;

}


#pragma mark - Button IB

- (IBAction)CBCloseButtonPress:(UIButton *)sender {
    self.CBSearchBox.text = @"";
}

- (IBAction)CBSearchButtonPress:(UIButton *)sender {
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    //request search
    [self sendTransRequest:@"COLABO_L103"];
    
    [self.CBSearchBox resignFirstResponder];
}
@end
