//
//  TastingController.m
//  cantoneseGame
//
//  Created by dw on 16/1/2.
//  Copyright © 2016年 slippers. All rights reserved.
//

#import "TastingController.h"
#import "config.h"
#import "Levoler.h"
#import "GameSaleController.h"
#import "Popup.h"
#import <AVFoundation/AVFoundation.h>
#import "config.h"
#import "WeixinActivity.h"

@import GoogleMobileAds;
@interface TastingController () <UIActionSheetDelegate,PopupDelegate>{
    
    NSString *txTitle;
    NSString *txSubTitle;
    NSString *txCancel;
    NSString *txSuccess;
    
    
    PopupBackGroundBlurType blurTpor;
    PopupIncomingTransitionType incomgorTp;
    PopupOutgoingTransitionType outgesgType;
    
    Popup *popry;
    
    
    AVAudioPlayer *playoring;
    
    NSArray *activtor;
    UIView* gmorLayer;
}
@property (strong, nonatomic) GameSaleController* contller;
@property (strong,nonatomic) GADInterstitial *intrstial;
@end

@implementation TastingController

//setup the view and instantiate the game controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    

 activtor = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    
    NSArray *imageArr = @[[UIImage imageNamed:@"backButtonImage.png"],[UIImage imageNamed:@"shareButtonImage.png"],  [UIImage imageNamed:@"menuClose.png"]];
    sideBot = [[CFSidorBarController alloc] initWithImages:imageArr];
    sideBot.delegate = self;
    
    _intrstial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-7330443893787901/1391670676"];
    [_intrstial loadRequest:[GADRequest request]];
    
    txTitle = @"Title";
    txSubTitle = @"Subtitledhdhgfhfgjhjhgjhghjgvhjhjfgfjgfjhgjhghgjhh\n   po   \n af\n \n \n \n \n \n \n \n aasfadsf\nfadf\nadf\n";

    incomgorTp=PopupIncomingTransitionTypeGhostAppear;
    outgesgType=PopupOutgoingTransitionTypeGrowDisappear;
    
    
    self.contller = [[GameSaleController alloc] init];
    
     self.view.backgroundColor=[UIColor whiteColor];
    
    //add one layer for all game elements
    
     gmorLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    NSString *backgrundImgNm=[NSString stringWithFormat:@"background%d.png",arc4random()%13 ];
    
    UIColor *bcgColur = [UIColor colorWithPatternImage: [UIImage imageNamed:backgrundImgNm]];
    gmorLayer.backgroundColor=bcgColur;
    
    NSLog(@"%f",kScreenWidth);
    NSLog(@"%f",kScreenHeight);
    [self.view addSubview: gmorLayer];
    
    self.contller.vGame = gmorLayer;
    
    __weak TastingController* weakSelf = self;
    self.contller.onAgramSled = ^(){

        //再加上有下一题的弹窗
        int thMaxInd=(int)[[NSUserDefaults standardUserDefaults]integerForKey:maxIndex];
        int rectlyIndex=self.indoxes+1;
        if (rectlyIndex>thMaxInd) {
            [[NSUserDefaults standardUserDefaults]setInteger:rectlyIndex forKey:maxIndex];
        }
        [weakSelf showduntPopper];
         //[interstitial presentFromRootViewController:self];
    };
    
    self.contller.wrongAgram=^(){
        [weakSelf showWrongPopper];
        // [interstitial presentFromRootViewController:self];
        
    };
    
    self.contller.getAnswAgram=^(){
        [weakSelf showTipsPopper];
        // [interstitial presentFromRootViewController:self];
        
    };
    
      [self showLovelly];
}

//show tha game menu on app start
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [sideBot insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 70, 50)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [sideBot remove];
}
#pragma mark - Game manu
-(void)showLovelly{
    
    NSString *bkgundImgName=[NSString stringWithFormat:@"background%d.png",arc4random()%13 ];
    //NSString *backgroundImageName=[NSString stringWithFormat:@"background13.png" ];
    
    UIColor *bgColuor = [UIColor colorWithPatternImage: [UIImage imageNamed:bkgundImgName]];
    //[self.view setBackgroundColor:bgColor];
    gmorLayer.backgroundColor=bgColuor;
    self.contller.levelor = [Levoler levoler];
    [self.contller dealloryWithNum:self.indoxes];
    
    Levoler *levolr=[Levoler levoler];
    
    NSString *answorn = [NSString stringWithFormat:@"%@",[levolr.lolArr[self.indoxes] objectForKey:@"answer"]];
    NSString *explion = [NSString stringWithFormat:@"%@",[levolr.lolArr[self.indoxes] objectForKey:@"explain"]];
    
    NSString *voicory = [NSString stringWithFormat:@"%@",[levolr.lolArr[self.indoxes] objectForKey:@"voice"]];
    
    txTitle=answorn;
    txSubTitle=explion;
    [self loadVoice:voicory];

}
-(void)backringTo{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"back");
}
-(void)showdownNextLevel{
    
    
    NSString *backgrdImgeNm=[NSString stringWithFormat:@"background%d.png",arc4random()%13 ];
    
    UIColor *bcgClour = [UIColor colorWithPatternImage: [UIImage imageNamed:backgrdImgeNm]];

    gmorLayer.backgroundColor=bcgClour;
    
    self.indoxes+=1;
    self.contller.levelor = [Levoler levoler];
    [self.contller dealloryWithNum:self.indoxes];
    
    Levoler *levolry=[Levoler levoler];
    
    
    NSString *answnr = [NSString stringWithFormat:@"%@",[levolry.lolArr[self.indoxes] objectForKey:@"answer"]];
    NSString *explane = [NSString stringWithFormat:@"%@",[levolry.lolArr[self.indoxes] objectForKey:@"explain"]];
    NSString *voicos = [NSString stringWithFormat:@"%@",[levolry.lolArr[self.indoxes] objectForKey:@"voice"]];
   
    txTitle=answnr;
    txSubTitle=explane;
    [self loadVoice:voicos];

}



#pragma mark Popup Methods

- (void)showduntPopper {
    
    popry=[[Popup alloc]initWithTitle:txTitle subTitle:txSubTitle haveOkButton:NO haveBackButton:YES haveVoiceButton:YES haveNextButton:YES haveRenewButton:NO];
    
    [popry setDelegate:self];
    [popry setBackgroundBlurType:blurTpor];
    [popry setIncomingTransition:incomgorTp];
    [popry setOutgoingTransition:outgesgType];
    [popry setRoundedCorners:YES];
    [popry showPopup];
    //加广告
    if ( arc4random()%6==1) {
        [self loadAdcry];
    }
    
}

-(void)showWrongPopper {
    
    NSString *tileFal=@"挑战失败";
    NSString *subTtl=@" ";
    popry=[[Popup alloc]initWithTitle:tileFal subTitle:subTtl haveOkButton:NO haveBackButton:YES haveVoiceButton:NO haveNextButton:NO haveRenewButton:YES];
    [popry setDelegate:self];
    [popry setBackgroundBlurType:blurTpor];
    [popry setIncomingTransition:incomgorTp];
    [popry setOutgoingTransition:outgesgType];
    [popry setRoundedCorners:YES];
    [popry showPopup];
    

    if ( arc4random()%3==1) {
        [self loadAdcry];
    }
    
    
}

-(void)showTipsPopper{
    NSString *tileFal=@"获取信息";
    NSString *subTle=@"如果你同意收看广告的话，按YES按钮可以获取一个正确的字。如果不同意按NO按钮退出。";
    
    popry=[[Popup alloc]initWithTitle:tileFal subTitle:subTle cancelTitle:@"NO" successTitle:@"YES"];

    
    [popry setDelegate:self];
    [popry setBackgroundBlurType:blurTpor];
    [popry setIncomingTransition:incomgorTp];
    [popry setOutgoingTransition:outgesgType];
    [popry setRoundedCorners:YES];
    [popry showPopup];
    
}


- (void)popupWillAppear:(Popup *)popup {
}

- (void)popupDidAppear:(Popup *)popup {
}

- (void)popupWilldisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType {
}

- (void)popupDidDisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType {
}

- (void)popupPressButton:(Popup *)popup buttonType:(PopupButtonType)buttonType {
    
    if (buttonType == PopupButtonCancel) {
        NSLog(@"popupPressButton - PopupButtonCancel");
    }
    else if (buttonType == PopupButtonSuccess) {
       
        [self.contller actionADviewHintment];
        //加一个延时先获取正确答案的动画输出一遍
        [self performSelector:@selector(loadAdcry) withObject:nil afterDelay:3.0f];
        
    }
    else if (buttonType == PopupButtonOk) {
        NSLog(@"popupPressButton - PopupButtonOk");
        
    }
    else if (buttonType == PopupButtonVoice) {
        NSLog(@"popupPressButton - PopupButtonVoice");
        [self playVoicor];
    }
    else if (buttonType == PopupButtonBack) {
        NSLog(@"popupPressButton - PopupButtonBack");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonType == PopupButtonNext) {
        NSLog(@"popupPressButton - PopupButtonNext");
        if (self.indoxes<44) {
            [self showdownNextLevel];
        }else{
            
           NSString* title=@"Well done";
           NSString* subTle=@"你已经通关了，感谢你的支持。如果喜欢这个游戏的话可以到iTunes上评论，很快会推出新的粤语解密游戏。敬请关注。";
            
        popry=[[Popup alloc]initWithTitle:title subTitle:subTle haveOkButton:YES haveBackButton:NO haveVoiceButton:NO haveNextButton:NO haveRenewButton:NO];
            
            
            [popry setDelegate:self];
            [popry setBackgroundBlurType:blurTpor];
            [popry setIncomingTransition:incomgorTp];
            [popry setOutgoingTransition:outgesgType];
            [popry setRoundedCorners:YES];
            [popry showPopup];
            
        }
        
    }
    else if (buttonType == PopupButtonRenew) {
        NSLog(@"popupPressButton - PopupButtonRenew");
        [self showLovelly];
    }
}

- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSLog(@"Dictionary from textfields: %@", dictionary);
    NSLog(@"Array from textfields: %@", stringArray);

}

//加载语音

-(void)loadVoice:(NSString*)voiceName
{

        NSString* suderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: voiceName];
        NSURL* sodURL = [NSURL fileURLWithPath: suderPath];
        
        //2 load the file contents
        NSError* ldError = nil;
        playoring = [[AVAudioPlayer alloc] initWithContentsOfURL:sodURL error: &ldError];
        playoring.volume=5;
        NSAssert(ldError==nil, @"load sound failed");
        
        //3 prepare the play
        playoring.numberOfLoops = 0;
        [playoring prepareToPlay];
    
}

-(void)playVoicor
{

    if (playoring.isPlaying) {
        playoring.currentTime = 0;
    } else {

        [playoring play];
  
    }
}

-(void)loadAdcry{
    [_intrstial presentFromRootViewController:self];
    _intrstial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-7330443893787901/1391670676"];
    [_intrstial loadRequest:[GADRequest request]];
    
}


- (void)menuButtonClicked:(int)index
{
    // Execute what ever you want
    switch (index) {
        case 0:
            NSLog(@"0");
            [self backringTo];

            break;
        case 1:
            NSLog(@"1");

            [self weChatShare];
            [self becomeFirstResponder];
            break;
        case 2:
            NSLog(@"2");
             break;
        default:
            break;
    }
}

- (void)weChatShare{
    
    NSString *tile = NSLocalizedString(@"tile",@"");
    NSString *theUrl = NSLocalizedString(@"theUrl",@"");
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[tile, [UIImage imageNamed:@"shareIcon.png"], [NSURL URLWithString:theUrl]] applicationActivities:activtor];
    activityView.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityView animated:YES completion:nil];
    }
    //if iPad
    else {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityView];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end


