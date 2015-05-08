//
//  CBIntroViewController.m
//  CBCollabo
//
//  Created by Chan Youvita on 3/23/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "CBIntroViewController.h"
#import "CBLoginViewController.h"

#define kRefreshTimeInSeconds 0.3

@interface CBIntroViewController ()<SecurityManagerDelegate,UIScrollViewDelegate>{
    UIView *slideMenu1;
    UIView *slideMenu2;
    UIView *slideMenu3;
    UIImageView *slide3Image;
    UIImageView *slide2Image;
    UIImageView *slide2ImageBg;
    UIImageView *slide1ImageBox;
    UIImageView *slide1ImageCalender;
    UIImageView *slide1ImageProgress;
    
    BOOL isLoadSlide1;
    BOOL isLoadSlide2;
    BOOL isLoadSlide3;
}

@end

@implementation CBIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    slideMenu1 = (UIView *)[self.view viewWithTag:1];
    slideMenu2 = (UIView *)[self.view viewWithTag:2];
    slideMenu3 = (UIView *)[self.view viewWithTag:3];
    
    slide2Image = (UIImageView*)[self.view viewWithTag:7];
    slide2ImageBg = (UIImageView*)[self.view viewWithTag:8];
    
    slide3Image = (UIImageView*)[self.view viewWithTag:9];
    
    
   
    slide1ImageBox = (UIImageView*)[self.view viewWithTag:6];
    slide1ImageCalender = (UIImageView*)[self.view viewWithTag:4];
    slide1ImageProgress = (UIImageView*)[self.view viewWithTag:5];
    
    self.scrollMenu.delegate = self;
    
    NSTimer *myTimerName;
    myTimerName = [NSTimer scheduledTimerWithTimeInterval: kRefreshTimeInSeconds
                                                   target:self
                                                 selector:@selector(handleTimer)
                                                 userInfo:nil
                                                  repeats:YES];

    NSTimer *slide2Timer;
    slide2Timer= [NSTimer scheduledTimerWithTimeInterval: 1
                                                   target:self
                                                 selector:@selector(scaleTimer)
                                                 userInfo:nil
                                                  repeats:YES];

    NSTimer *slide1Timer;
    slide1Timer= [NSTimer scheduledTimerWithTimeInterval: 1
                                                  target:self
                                                selector:@selector(onTimer)
                                                userInfo:nil
                                                 repeats:YES];

    
    [self addViewToScrollView];

  }

- (void)onTimer{
    if (isLoadSlide1) {
        slide1ImageCalender.highlighted = NO;
        slide1ImageProgress.highlighted = YES;
        slide1ImageBox.highlighted = YES;
        isLoadSlide1 = NO;
        
    }else{
        slide1ImageCalender.highlighted = YES;
        slide1ImageProgress.highlighted = NO;
        slide1ImageBox.highlighted = NO;
        isLoadSlide1 = YES;
    }
}

// Slide 2 animation
-(void)scaleTimer{
    slide2ImageBg.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //change time duration according to requirement
        // animate it to the identity transform (100% scale)
        slide2ImageBg.transform = CGAffineTransformIdentity;
        if (isLoadSlide2) {
            slide2Image.highlighted = NO;
            isLoadSlide2 = NO;
        }else{
            slide2Image.highlighted = YES;
            isLoadSlide2 = YES;
        }

    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
  

}

// Slide 3 animation
-(void)handleTimer
{
    if (isLoadSlide3) {
        [slide3Image layer].transform = CATransform3DMakeRotation(1, 0, 0, 1);
        isLoadSlide3 = NO;
    }else{
        [slide3Image layer].transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        isLoadSlide3 = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendLogin:(UIButton *)sender {
    [[SessionManager sharedSessionManager] setIsFirstSetUp:YES]; // The first view intro
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CBLoginViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CBLoginViewController"];
    [self.navigationController pushViewController:vc animated:NO];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x==0.000000) {
        slideMenu1.hidden=NO;
        slideMenu2.hidden=YES;
        slideMenu3.hidden=YES;
      
    }
    else if(scrollView.contentOffset.x==320.000000){
        slideMenu1.hidden=YES;
        slideMenu2.hidden=NO;
        slideMenu3.hidden=YES;
     
    }
    else if (scrollView.contentOffset.x==640.000000) {
        slideMenu1.hidden=YES;
        slideMenu2.hidden=YES;
        slideMenu3.hidden=NO;
    }
}

-(void)addViewToScrollView{
    NSArray *arr = [NSArray arrayWithObjects:[self slide1],[self slide2],[self slide3],nil];
    for (int i =0 ; i<[arr count]; i++) {
        CGRect frame;
        frame.origin.x = self.scrollMenu.frame.size.width*i;
        frame.origin.y=0;
        frame.size=self.scrollMenu.frame.size;
        UIView *subView = [[UIView alloc]initWithFrame:frame];
        [self.scrollMenu addSubview:subView];
    }
    self.scrollMenu.contentSize = CGSizeMake(self.scrollMenu.frame.size.width * [arr count], self.scrollMenu.frame.size.height);
}
@end
