//
//  CBWriteCommViewController.h
//  CBCollabo
//
//  Created by Chan Youvita on 4/9/15.
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

@protocol CBWriteCommViewControllerDelegate <NSObject>

@optional
- (void)didSaveData;
@end

@interface CBWriteCommViewController : WCViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,QBImagePickerControllerDelegate>
@property (nonatomic, weak)id<CBWriteCommViewControllerDelegate> delegate;

@property (nonatomic)BOOL isModify;
@property (nonatomic, copy)NSString *COLABO_SRNO;
@property (nonatomic, strong)NSMutableArray *arrDataModify;

@property (weak, nonatomic) IBOutlet UITextView *CBContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onTopOptionView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewImage;
- (IBAction)onGestureGalleryButtonPress:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewImageHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFile;
@property (weak, nonatomic) IBOutlet UIImageView *lineTableView;

@end
