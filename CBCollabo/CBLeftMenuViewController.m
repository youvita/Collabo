//
//  LeftMenuViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/27/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBLeftMenuViewController.h"

@interface CBLeftMenuViewController ()

@end

@implementation CBLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SessionManager sharedSessionManager].categoryDataArr count] + 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view            = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 20.0f)];
    view.backgroundColor    = RGB(80, 80, 80);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell                    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor    = RGB(80, 80, 80);
        cell.accessoryType      = UITableViewCellAccessoryNone;
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        
        // 아이콘 이미지
        UIImageView *iconImage       = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, 14.0f, 25.0f, 29.0f)];
        iconImage.image              = [UIImage imageNamed:@"menu_collabo_icon_normal.png"];
        iconImage.highlightedImage   = [UIImage imageNamed:@"menu_collabo_icon_select.png"];
        iconImage.backgroundColor    = [UIColor clearColor];
        iconImage.tag                = 301;
        [cell.contentView addSubview:iconImage];
        
        // 타이틀
        UILabel *titleLabel           = [[UILabel alloc] initWithFrame:CGRectMake(46.0f, 20.0f, self.tableView.frame.size.width - 58.0f, 16.0f)];
        titleLabel.backgroundColor    = [UIColor clearColor];
        titleLabel.font               = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment      = NSTextAlignmentLeft;
        titleLabel.textColor          = RGB(255, 255, 255);
        titleLabel.tag                = 201;
        [cell.contentView addSubview:titleLabel];
        
        // 서브 타이틀(동기화)
        UILabel *subtitleLabel           = [[UILabel alloc] initWithFrame:CGRectMake(46.0f, 40.0f, self.tableView.frame.size.width - 58.0f, 13.0f)];
        subtitleLabel.backgroundColor    = [UIColor clearColor];
        subtitleLabel.font               = [UIFont systemFontOfSize:12.0f];
        subtitleLabel.textAlignment      = NSTextAlignmentLeft;
        subtitleLabel.textColor          = RGB(160, 160, 160);
        subtitleLabel.tag                = 101;
        [cell.contentView addSubview:subtitleLabel];
        
        // 구분 라인
        UIView *lineView            = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 56.0f, self.tableView.frame.size.width, 1.0f)];
        lineView.backgroundColor    = RGB(95, 95, 95);
        [cell.contentView addSubview:lineView];
        
    }
    
//    UILabel *lblTitle       = (UILabel *)[cell.contentView viewWithTag:201];
//    UILabel *subtitleLabel  = (UILabel *)[cell.contentView viewWithTag:101];
//    UIImageView *imgIcon    = (UIImageView *)[cell.contentView viewWithTag:301];
    
    return cell;
}
@end
