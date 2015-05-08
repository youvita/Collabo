//
//  CBCreateCollaboViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 4/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBCreateCollaboViewController.h"

#define kKeyboarOffset 25.0f

@interface CBCreateCollaboViewController ()<UIImagePickerControllerDelegate>{
    SpinnerView *spinnerView;
    NSMutableArray *resDataArray;
    NSMutableArray *imageDataArray;
    NSMutableArray *fileDataArray;
    CGFloat yPoint;
    CGFloat cellHeight;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalTopViewOption;

@end

@implementation CBCreateCollaboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageDataArray = [[NSMutableArray alloc] init];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"top_textback_btn.png" highlightImageCode:@"top_textback_btn_p.png"];
    
    [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_save_btn.png" highlightImageCode:@"top_save_btn_p.png"];
    
    self.verticalTopViewOption.constant = 455;
    self.tableViewImage.hidden = YES;
    self.CBTitleCollabo.delegate = self;
    self.CBContentCollabo.delegate = self;
    
    // Update checking
    if (self.isUpdateColabo == YES) {
        self.title = @"콜라보 수정"; // Update
        self.VerticalTopContentView.constant = -110;
        self.CBTitleCollabo.text = self.arrDataUpdateCollabo[0][@"TTL"];
        self.CBContentCollabo.text = self.arrDataUpdateCollabo[0][@"CNTN"];
        NSMutableArray *atchRec = self.arrDataUpdateCollabo[0][@"ATCH_REC"];

        if (atchRec.count !=0) {
            for (int i=0; i<atchRec.count; i++) {
                    // Type of image
                    // Set image source
                    NSURL *urlImage = [[NSURL alloc] initWithString:atchRec[i][@"ATCH_URL"]];
                    NSData *data = [NSData dataWithContentsOfURL:urlImage];
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    // Set image name
                    NSString *imageSize = atchRec[i][@"FILE_SIZE"];
                    NSString *imageHeigth = [[NSString stringWithFormat:@"%f",image.size.height]substringToIndex:4];
                    NSString *imageWidht = [[NSString stringWithFormat:@"%f",image.size.width]substringToIndex:4];
                    NSString *imageName = [NSString stringWithFormat:@"%@ X %@ | %@",imageWidht,imageHeigth,[SysUtils transformedValue:imageSize]];
                    
                    NSMutableDictionary *imageInfo = [[NSMutableDictionary alloc] init];
                    [imageInfo setObject:imageName forKey:@"IMG_NAME"];
                    [imageInfo setObject:image forKey:@"IMG_SOURCE"];
                    [imageInfo setObject:atchRec[i][@"ATCH_SRNO"] forKey:@"ATCH_SRNO"];
                    [imageInfo setObject:@"" forKey:@"OTPT_SQNC"];
                    
                    [imageDataArray addObject:imageInfo];
                    
                    // Limited row of table view to show 2 record
                    if (imageDataArray.count <= 2) {
                        cellHeight = cellHeight + 55;
                    }
                }// End for loop
 
            self.VerticalTopContentView.constant = 0;
            self.tableViewImageHeight.constant = cellHeight;
            self.tableViewImage.hidden = NO;
            [self.tableViewImage reloadData];
        }
        
        
        self.tableViewFile.hidden = YES;
        self.CBTextViewTin.hidden = YES;
        
    }else{
        self.title = @"콜라보 작성"; // Create
        
        self.VerticalTopContentView.constant = -110;
        self.tableViewFile.hidden = YES;
        self.tableViewImage.hidden = YES;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

- (void)rightButtonClicked:(UIButton *)sender{
    
    if ([SysUtils isNull:self.CBTitleCollabo.text]) {
        [SysUtils showMessage:@"제목을 입력해주세요"];
    }else if([SysUtils isNull:self.CBContentCollabo.text]){
        [SysUtils showMessage:@"함께 주고받을 콜라보 내용을 작성하세요."];
    }else{
        if (self.isUpdateColabo == YES) {
            [self sendTransRequest:@"COLABO_U101"];
        }else{
            [self sendTransRequest:@"COLABO_C102"];
        }
    }
    
}

- (UIView *)superViewOfType:(Class)paramSuperViewClass forView:(UIView *)paramView{
    ///====== This Method is for Take cell form UITableViewCell
    if (paramView.superview != nil) {
        if ([paramView.superview isKindOfClass:paramSuperViewClass]) {
            return paramView.superview;
        }else{
            return [self superViewOfType:paramSuperViewClass forView:paramView.superview];
        }
    }
    return nil;
}


- (void)onDeleted:(id)sender{
    UITableViewCell *cell = (UITableViewCell *) [self superViewOfType:[UITableViewCell class] forView:sender];
    NSIndexPath * indexPath = [self.tableViewImage indexPathForCell:cell];
    [imageDataArray removeObjectAtIndex:indexPath.row];
    
    [self.tableViewImage beginUpdates];
    [self.tableViewImage deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableViewImage endUpdates];
    
    if(imageDataArray.count==0){
        self.tableViewImage.hidden=YES;
    }
    
    if (imageDataArray.count < 2) {
        // Remove height of table cell
        CGFloat removeHeight = self.tableViewImageHeight.constant - 55;
        self.tableViewImageHeight.constant = removeHeight;
        NSLog(@"%f",removeHeight);
    }
  
    NSLog(@"%@",imageDataArray);

}

- (void)onMoved:(id)sender{
    
}


#pragma mark - Request and Respond

- (void)sendTransRequest:tranCd{
    spinnerView =[SpinnerView loadSpinnerIntoView:self.view];
    NSString *userID = [SessionManager sharedSessionManager].userID;// getUserID
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    NSMutableArray *fileRec = [[NSMutableArray alloc] init];
    
    if (imageDataArray.count !=0) {
        for (int i=0; i<imageDataArray.count; i++) {
            //Set Photo Date and original image name
            NSString *date = [self currentDateandTime];
            NSString *originalImage =[NSString stringWithFormat:@"%@_image.jpg",date];
            
            //Convert image to string
            UIImage *image = imageDataArray[i][@"IMG_SOURCE"];
            NSString *fileImage = [self imageToNSString:image];
            
            NSDictionary *dic = @{
                                  @"SAVE_FILE_NM" : fileImage,
                                  @"ORG_FILE_NM"  : originalImage
                                  };
            
            [fileRec addObject:dic];
        }
    }
    
    [reqData setObject:userID forKey:@"USER_ID"];
    [reqData setObject:self.CBTitleCollabo.text forKey:@"TTL"];
    [reqData setObject:self.CBContentCollabo.text forKey:@"CNTN"];
    [reqData setObject:fileRec forKey:@"FILE_REC"];
    
    if ([tranCd isEqualToString:@"COLABO_C102"]) {
        [reqData setObject:self.resDataTemp forKey:@"SENDIENCE_REC"];
    }else{
        [reqData setObject:self.arrDataUpdateCollabo[0][@"COLABO_SRNO"] forKey:@"COLABO_SRNO"];
    }
    
    [super sendTransaction:tranCd requestDictionary:reqData];
}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    [spinnerView removeSpinnerView]; // remove wating screen
//    resDataArray = [[NSMutableArray alloc] initWithArray:responseArray[0][@"COLABO_FLD_REC"]];
    
    if ([transCode isEqualToString:@"COLABO_C102"]) {
        [self performSegueWithIdentifier:@"SegueCBList102View" sender:nil];
    }else{
        [self.delegate didUpdateCollabo];
        // call back
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(keyboardFrameBeginRect));
    yPoint = keyboardFrameBeginRect.origin.y;

     NSLog(@"Nontifi %f",yPoint);
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell                 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType   = UITableViewCellAccessoryNone;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    for(UIView *v in [cell.contentView subviews])
    {
        if([v isKindOfClass:[UIButton class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UIImageView class]]){
            [v removeFromSuperview];
        }else if([v isKindOfClass:[UILabel class]]){
            [v removeFromSuperview];
        }
    }
    
    // Set image
    UIImageView *imageSource    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 71, 54)];
    imageSource.image           = imageDataArray[indexPath.row][@"IMG_SOURCE"];
    [cell.contentView addSubview:imageSource];
    
    // Set name
    NSString *imageNameString   = imageDataArray[indexPath.row][@"IMG_NAME"];
      // Fix size label
    CGFloat width = [SysUtils measureTextWidth:imageNameString fontName:@"Helvetica" fontSize:12 constrainedToSize:CGSizeMake(236,21)];

    UILabel  *imageName         = [[UILabel alloc] initWithFrame:CGRectMake(86, 17, width, 21)];
    imageName.font              =[UIFont fontWithName:@"Helvetica" size:12.0f];
    imageName.textColor         = RGB(110, 110, 110);
    imageName.text              = imageNameString;
    imageName.textAlignment     = NSTextAlignmentLeft;
    [cell.contentView addSubview:imageName];

    // Set button delete
    UIImage *imageDelete          = [UIImage imageNamed:@"file_del_btn.png"];
    UIButton *imageButtonDelete   = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButtonDelete.frame       = CGRectMake(width+96, 19, 14, 16);
    [imageButtonDelete setBackgroundImage:imageDelete forState:UIControlStateNormal];
    [imageButtonDelete addTarget:self action:@selector(onDeleted:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:imageButtonDelete];


    // Set button move
    UIImage *imageMoveNormal        = [UIImage imageNamed:@"list_move_btn.png"];
    UIButton *imageButtonMove       = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButtonMove.frame           = CGRectMake(286, 15, 22, 24);
    [imageButtonMove setBackgroundImage:imageMoveNormal forState:UIControlStateNormal];
    
    UIImage *imageMoveHighlighted   = [UIImage imageNamed:@"list_move_btn_p.png"];
    [imageButtonMove setBackgroundImage:imageMoveHighlighted forState:UIControlStateHighlighted];

    [imageButtonMove addTarget:self action:@selector(onMoved:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:imageButtonMove];

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return imageDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //    if( IS_IPHONE_5 )   return;
    
    if( textField == self.CBTitleCollabo){
        self.verticalTopViewOption.constant = 205;
        
        if ([SysUtils isNull:self.CBTextViewTin.text]) {
           self.CBTextViewTin.hidden = NO;
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    //    if( IS_IPHONE_5 )   return;
    
    if( textField == self.CBTitleCollabo ){
        self.verticalTopViewOption.constant = 455;
        
        if ([SysUtils isNull:self.CBTextViewTin.text]) {
            self.CBTextViewTin.hidden = NO;
        }
    }
}


#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.CBTextViewTin.hidden = YES;
    self.verticalTopViewOption.constant = 205;

}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([SysUtils isNull:textView.text]) {
        self.CBTextViewTin.hidden = NO;
    }
}

- (IBAction)onGestureGalleryButtonPress:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
   
    QBImagePickerController *imagePickerController  = [[QBImagePickerController alloc] init];
    imagePickerController.delegate                  = self;
    imagePickerController.allowsMultipleSelection   = 1;
   
    
    imagePickerController.maximumNumberOfSelection  = 5-[imageDataArray count];
    
    if(imagePickerController.maximumNumberOfSelection==0){
        UIAlertView *AL=[[UIAlertView alloc]initWithTitle:@"" message:@"사진은 최대 5장까지 가능합니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles: nil];
        [AL show];
    }else{
        UINavigationController *navigationController    = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    

}

- (IBAction)onGestureCameraButtonPress:(UITapGestureRecognizer *)sender {

}

#pragma mark - QBImageView Delegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    NSLog(@"True");
    
    // if image nothing set height of tableview cell zero
    if (imageDataArray.count==0) {
        cellHeight = 0;
    }
     NSLog(@"%d",assets.count);
    
    for (ALAsset *arrImages in assets) {
        ALAssetRepresentation *assetObject = [arrImages defaultRepresentation];
        UIImage *imageSource = [UIImage imageWithCGImage:[assetObject fullResolutionImage]];
        
        NSData *imgData            = UIImageJPEGRepresentation([UIImage imageWithCGImage:[assetObject fullResolutionImage]], 0.0);
        NSString *imageSize         = [NSString stringWithFormat:@"%lu",(unsigned long)[imgData length]];
        
        NSString *imageHeigth = [[NSString stringWithFormat:@"%f",[UIImage imageWithCGImage:[assetObject fullResolutionImage]].size.height]substringToIndex:4];

        NSString *imageWidht = [[NSString stringWithFormat:@"%f",[UIImage imageWithCGImage:[assetObject fullResolutionImage]].size.width]substringToIndex:4];
        
        NSString *imageName = [NSString stringWithFormat:@"%@ X %@ | %@",imageWidht,imageHeigth,[SysUtils transformedValue:imageSize]];
        
        NSLog(@"%@",imageName);
        NSMutableDictionary *imageInfo = [[NSMutableDictionary alloc] init];
        [imageInfo setObject:imageName forKey:@"IMG_NAME"];
        [imageInfo setObject:imageSource forKey:@"IMG_SOURCE"];
        [imageDataArray addObject:imageInfo];
        
        // Limited row of table view to show 2 record
        if (imageDataArray.count <= 2) {
           cellHeight = cellHeight + 55;
        }
        

    }
    
     NSLog(@"%f",cellHeight);
    
    self.VerticalTopContentView.constant = 0;
    self.tableViewImageHeight.constant = cellHeight;
    self.verticalTopViewOption.constant = 455;
    self.tableViewImage.hidden = NO;
    [self.tableViewImage reloadData];
    [self dismissImagePickerController];

}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"Cancel Click");
    [self dismissImagePickerController];
}

- (void)dismissImagePickerController {
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (NSString *)currentDateandTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMddyyyy_HHmmssSS"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    return dateString;
}

-(NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *img =[UIImage imageWithData:imageData];
    
    NSData *jpgImage = UIImageJPEGRepresentation(img,0.0);
    NSString *encodedData = [[NSString alloc]initWithString:[jpgImage base64Encoding]];
    
    return encodedData;
}



@end
