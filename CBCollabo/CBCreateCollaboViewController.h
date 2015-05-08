//
//  CBCreateCollaboViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "AppUtils.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import "SpinnerView.h"
#import "AllUtils.h"
#import "QBImagePickerController.h"

@protocol CBCreateCollaboViewControllerDelegate <NSObject>

@optional
- (void)didUpdateCollabo;
@end


@interface CBCreateCollaboViewController : WCViewController<UITextViewDelegate,UITextFieldDelegate,QBImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak)id<CBCreateCollaboViewControllerDelegate> delegate;
@property (nonatomic ,strong)NSMutableArray *arrDataUpdateCollabo;
@property (nonatomic)BOOL isUpdateColabo;

@property (weak, nonatomic) IBOutlet UITextField *CBTitleCollabo;
@property (weak, nonatomic) IBOutlet UITextView *CBContentCollabo;
@property (weak, nonatomic) IBOutlet UILabel *CBTextViewTin;

@property (nonatomic, strong)NSMutableArray *resDataTemp;
@property (weak, nonatomic) IBOutlet UIView *CBViewOption;
@property (weak, nonatomic) IBOutlet UITableView *tableViewImage;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VerticalTopContentView;
- (IBAction)onGestureGalleryButtonPress:(UITapGestureRecognizer *)sender;
- (IBAction)onGestureCameraButtonPress:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewImageHeight;


@end
