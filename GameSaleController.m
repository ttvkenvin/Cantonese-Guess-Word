//
//  GameSaleController.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "GameSaleController.h"
#import "config.h"
#import "TiloryView.h"
#import "TargottryView.h"
#import "ExpledorView.h"
#import "StortyDustView.h"
#import "Popup.h"

@interface GameSaleController ()<PopupDelegate>{
    NSString *tileTxt;
    NSString *subTilext;
    
    
    PopupBackGroundBlurType blurType;
    PopupIncomingTransitionType incomgType;
    PopupOutgoingTransitionType outgogType;
    
    Popup *popor;
    
}

@end

@implementation GameSaleController
{
  //tile lists
  NSMutableArray* _tileArr;
  NSMutableArray* _targetArr;
  
  //stopwatch variables
  int _secdsLeft;
  NSTimer* _timory;
    
    UIImageView *ivLifeOne;
    UIImageView *ivLifeTwo;
    UIImageView *ivLifeThree;
    
    int lifesValue;
}

//判断设备类型
-(bool)checkorOutDevice:(NSString*)name

{
    NSString* devortType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", devortType);
    
    NSRange rungor = [devortType rangeOfString:name];
    return rungor.location != NSNotFound;
}

//initialize the game controller
-(instancetype)init
{
  self = [super init];
  if (self != nil) {
    //initialize
    self.gData = [[GamorData alloc] init];
    
    self.audtController = [[AudortController alloc] init];
    [self.audtController previousloadAudioEffects: kAudioEffectFiles];
  }
  return self;
}

//fetches a random anagram, deals the letter tiles and creates the targets
-(void)dealloryWithNum:(int)num
{
   //设置popview的弹出，回收等属性
    blurType = PopupBackGroundBlurTypeNone;
    incomgType = PopupIncomingTransitionTypeFallWithGravity;
    outgogType = PopupOutgoingTransitionTypeFallWithGravity;
    
    //用于判断的设备是iPad 还是iphone
    NSLog(@"oo");
    NSString *  nstringIphone=@"iPhone";
    NSString *  nstringIpod=@"iPod";
    NSString *  nstrIpad=@"iPad";
    bool  bIPhne=false;
    bool  bIPod=false;
    bool  bIPad=false;
    bIPhne = [self  checkorOutDevice:nstringIphone];
    bIPod=[self checkorOutDevice:nstringIpod];
    bIPad=[self checkorOutDevice:nstrIpad];
    
    
  NSAssert(self.levelor.lolArr, @"no level loaded");
  
    NSString *questn = [NSString stringWithFormat:@"%@",[self.levelor.lolArr[num] objectForKey:@"question"]];
    NSString *answor = [NSString stringWithFormat:@"%@",[self.levelor.lolArr[num] objectForKey:@"answer"]];
    NSString *tippsr = [NSString stringWithFormat:@"%@",[self.levelor.lolArr[num] objectForKey:@"tips"]];
    
    subTilext = tippsr;
    tileTxt = @"Tips";
  
  int anOnelen = [questn length];
  int anTwolen = [answor length];
  
  NSLog(@"phrase1[%i]: %@", anOnelen, questn);
  NSLog(@"phrase2[%i]: %@", anTwolen, answor);
  
  //calculate the tile size
  float tileSd = ceilf( kScreenWidth*0.9 / (float)MAX(anOnelen, anTwolen) ) - kTileMargin;
    
    float tileSd1 = ceilf( kScreenWidth*0.9 / 5.0 )- kTileMargin;

  //get the left margin for first tile
  float xOffsttor = (kScreenWidth - 5 * (tileSd1 + kTileMargin))/2;
    
  
  //adjust for tile center (instead the tile's origin)
  xOffsttor += tileSd1/2;

  // initialize target list
  _targetArr = [NSMutableArray arrayWithCapacity: anTwolen];
  
  // create targets
  for (int i=0;i<anTwolen;i++) {
    NSString* lottory = [answor substringWithRange:NSMakeRange(i, 1)];
    
    if (![lottory isEqualToString:@" "]) {
      TargottryView* targtor = [[TargottryView alloc] initWithLottor:lottory andSideLength:tileSd1];
        if (bIPad) {
            targtor.center = CGPointMake(xOffsttor + i*(tileSd1 + kTileMargin), kScreenHeight/3*2-tileSd1*2);
        }
        else{
            targtor.center = CGPointMake(xOffsttor + i*(tileSd1 + kTileMargin), kScreenHeight/3*2-tileSd1*3);
        }
      [self.vGame addSubview:targtor];
      [_targetArr addObject: targtor];
    }
  }
  
  //initialize tile list
  _tileArr = [NSMutableArray arrayWithCapacity: anOnelen];
  
  //create tiles
  for (int i=0;i<anOnelen;i++) {
    NSString* lttort = [questn substringWithRange:NSMakeRange(i, 1)];
    
    if (![lttort isEqualToString:@" "]) {
      TiloryView* vTile = [[TiloryView alloc] initWithLottory:lttort andSideLength:tileSd1];
        
        
        int higtInt=floor(i/5);
        int wegtInt=i%5;
        
        
      vTile.center = CGPointMake(xOffsttor + wegtInt*(tileSd1 + kTileMargin), higtInt*kScreenHeight/8+kScreenHeight/3*2);

      vTile.delegate = self;
      
      [self.vGame addSubview:vTile];
      [_tileArr addObject: vTile];
    }
  }
    
    //tipsButton
    UIImage* img = [UIImage imageNamed:@"btn"];
    
    
    //the help button
    self.bttunHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bttunHelp setTitle:@"Tips" forState:UIControlStateNormal];
    self.bttunHelp.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
    
    [self.bttunHelp setBackgroundImage:img forState:UIControlStateNormal];
    if (bIPad) {
    self.bttunHelp.frame = CGRectMake(kTileMargin,  kScreenHeight/3*2-tileSd1*3-tileSd1/2-5, img.size.width/img.size.height*tileSd1, img.size.height/img.size.height*tileSd1);
    }else{
        self.bttunHelp.frame = CGRectMake(kTileMargin,  kScreenHeight/3*2-tileSd1*5, img.size.width/img.size.height*tileSd1, img.size.height/img.size.height*tileSd1);
    }
    //self.btnHelp.center=CGPointMake(kTileMargin, kScreenHeight/3*2-tileSide1*3);
    self.bttunHelp.alpha = 0.9;
    
    [self.bttunHelp addTarget:self action:@selector(gottorTips:) forControlEvents:UIControlEventTouchUpInside];
    [self.vGame addSubview: self.bttunHelp];
    
    
    //the help button
    self.getAnswsBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getAnswsBttn setTitle:@"✇" forState:UIControlStateNormal];
    self.getAnswsBttn.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/7 ];
    
    self.getAnswsBttn.backgroundColor=[UIColor redColor];
    
    
    if (bIPad) {
        self.getAnswsBttn.frame = CGRectMake(2*kTileMargin+1.7*img.size.width/img.size.height*tileSd1,  kScreenHeight/3*2-tileSd1*3-tileSd1/2-5,tileSd1, tileSd1);
    }else{

        self.getAnswsBttn.frame = CGRectMake(2*kTileMargin+1.7*img.size.width/img.size.height*tileSd1,  kScreenHeight/3*2-tileSd1*5, tileSd1, tileSd1);
    }
    //self.btnHelp.frame=
    self.getAnswsBttn.layer.masksToBounds = YES;
    self.getAnswsBttn.layer.cornerRadius = tileSd1/2;
    self.getAnswsBttn.alpha = 1.0;
    
    [self.getAnswsBttn addTarget:self action:@selector(gettoryAnswers:) forControlEvents:UIControlEventTouchUpInside];
    [self.vGame addSubview: self.getAnswsBttn];
    
    
    lifesValue = 3;
    
    UIImage * lifeImg=[UIImage imageNamed:@"heart.png"];
    ivLifeOne = [[UIImageView alloc]initWithFrame:CGRectMake(kTileMargin, 0, lifeImg.size.width/lifeImg.size.height*tileSd1, lifeImg.size.height/lifeImg.size.height*tileSd1)];
     ivLifeOne.center = CGPointMake(xOffsttor + 1*(tileSd1 + kTileMargin),tileSd1/2+30);
    [ivLifeOne setImage:lifeImg];
    [self.vGame addSubview: ivLifeOne];
    
    
    ivLifeTwo = [[UIImageView alloc]initWithFrame:CGRectMake(kTileMargin, 0, lifeImg.size.width/lifeImg.size.height*tileSd1, lifeImg.size.height/lifeImg.size.height*tileSd1)];
    ivLifeTwo.center = CGPointMake(xOffsttor + 2*(tileSd1 + kTileMargin),tileSd1/2+30);
    [ivLifeTwo setImage:lifeImg];
    [self.vGame addSubview: ivLifeTwo];
    
    ivLifeThree = [[UIImageView alloc]initWithFrame:CGRectMake(kTileMargin, 0, lifeImg.size.width/lifeImg.size.height*tileSd1, lifeImg.size.height/lifeImg.size.height*tileSd1)];
    ivLifeThree.center = CGPointMake(xOffsttor + 3*(tileSd1 + kTileMargin),tileSd1/2+30);
    [ivLifeThree setImage:lifeImg];
    [self.vGame addSubview: ivLifeThree];
}


-(void)gottorTips:(UIButton *)sender
{
  
    [self showduntPopper];
}

-(void)gettoryAnswers:(id)sender{
    self.getAnswAgram();
}

//a tile was dragged, check if matches a target
-(void)tileView:(TiloryView*)tileView didDragToPoint:(CGPoint)pt
{
  TargottryView* vTarget = nil;
  
  for (TargottryView* tv in _targetArr) {
    if (CGRectContainsPoint(tv.frame, pt)) {
      vTarget = tv;
      break;
    }
  }
  
  // check if target was found
  if (vTarget!=nil) {
    
    // check if letter matches
    if ([vTarget.lottory isEqualToString: tileView.lottor]) {
      
      [self placeComentTile:tileView atTarget:vTarget];
      
      //more stuff to do on success here
      [self.audtController playingEffect: kSoundDing];

      //check for finished game
      [self chckoutForSuccess];
    
    } else {

      //visualize the mistake
      [tileView randmantromize];
      
      [UIView animateWithDuration:0.35
                            delay:0.00
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^{
                         tileView.center = CGPointMake(tileView.center.x + randomf(-20, 20),
                                                       tileView.center.y + randomf(20, 30));
                       } completion:nil];

      //more stuff to do on failure here
      [self.audtController playingEffect:kSoundWrong];
      
        lifesValue -= 1;
        [self lifeImageTime];
        if (lifesValue<=0) {

     //延时1秒再弹出popView
        [self performSelector:@selector(gamoringOver) withObject:nil afterDelay:1];

        }
    }
  }
}

-(void)gamoringOver{
                [self clearingBoard];
                 self.wrongAgram();
}


-(void)placeComentTile:(TiloryView*)tileView atTarget:(TargottryView*)targetView
{
    targetView.isMatches = YES;
  tileView.isMatchor = YES;
  
  tileView.userInteractionEnabled = NO;
  
  [UIView animateWithDuration:0.35
                        delay:0.00
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     tileView.center = targetView.center;
                     tileView.transform = CGAffineTransformIdentity;
                   }
                   completion:^(BOOL finished){
                     targetView.hidden = YES;
                   }];

  ExpledorView* vExplode = [[ExpledorView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
  [tileView.superview addSubview: vExplode];
  [tileView.superview sendSubviewToBack:vExplode];
}

-(void)chckoutForSuccess
{
  for (TargottryView* tagt in _targetArr) {
    //no success, bail out
      if (tagt.isMatches==NO) return;
  }
  
  NSLog(@"Game Over!");

  [self.audtController playingEffect:kSoundWin];
  
  //win animation
  TargottryView* frtTargt = _targetArr[0];
  
  int strX = 0;
  int endinX = kScreenWidth + 300;
  int staY = frtTargt.center.y;
  
  StortyDustView* vStars = [[StortyDustView alloc] initWithFrame:CGRectMake(strX, staY, 10, 10)];
  [self.vGame addSubview:vStars];
  [self.vGame sendSubviewToBack:vStars];
    

   
    
  [UIView animateWithDuration:3
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     vStars.center = CGPointMake(endinX, staY);
                   } completion:^(BOOL finished) {
                     
                     //game finished
                     [vStars removeFromSuperview];
                     
                     //when animation is finished, show menu
                     [self clearingBoard];
                     self.onAgramSled();
                       

                   }];
}

//the user pressed the hint button
//按看广告要答案时候调用的方法
-(void)actionADviewHintment
{

  TargottryView* vTarget = nil;
  for (TargottryView* tgv in _targetArr) {
      if (tgv.isMatches==NO) {
      vTarget = tgv;
      break;
    }
  }
  
  // find the first tile, matching the target
  TiloryView* vtile = nil;
  for (TiloryView* tlv in _tileArr) {
    if (tlv.isMatchor==NO && [tlv.lottor isEqualToString:vTarget.lottory]) {
      vtile = tlv;
      break;
    }
  }

  // don't want the tile sliding under other tiles
  [self.vGame bringSubviewToFront:vtile];
  
  //show the animation to the user
  [UIView animateWithDuration:1.5
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     vtile.center = vTarget.center;
                   } completion:^(BOOL finished) {
                     // adjust view on spot
                     [self placeComentTile:vtile atTarget:vTarget];
                     
                     // check for finished game
                     [self chckoutForSuccess];
                   }];

}

//clear the tiles and targets
-(void)clearingBoard
{
  [_tileArr removeAllObjects];
  [_targetArr removeAllObjects];
  
  for (UIView *vw in self.vGame.subviews) {
    [vw removeFromSuperview];
  }
}

#pragma mark Popup Methods

- (void)showduntPopper {
    
     popor = [[Popup alloc]initWithTitle:tileTxt subTitle:subTilext haveOkButton:YES haveBackButton:NO haveVoiceButton:NO haveNextButton:NO haveRenewButton:NO];
    
    [popor setDelegate:self];
    [popor setBackgroundBlurType:blurType];
    [popor setIncomingTransition:incomgType];
    [popor setOutgoingTransition:outgogType];
    [popor setRoundedCorners:YES];
    [popor showPopup];
    
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
        NSLog(@"popupPressButton - PopupButtonSuccess");
    }
    else if (buttonType == PopupButtonOk) {
        NSLog(@"popupPressButton - PopupButtonOk");

    }
    else if (buttonType == PopupButtonVoice) {
        NSLog(@"popupPressButton - PopupButtonVoic");
    }
    else if (buttonType == PopupButtonBack) {
        NSLog(@"popupPressButton - PopupButtonBack");
    }
    else if (buttonType == PopupButtonNext) {
        NSLog(@"popupPressButton - PopupButtonNext");
    }
    
}

- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSLog(@"Dictionary from textfields: %@", dictionary);
    NSLog(@"Array from textfields: %@", stringArray);

}

-(void)lifeImageTime
{
    switch (lifesValue) {
        case 3:
            
            break;
        case 2:
            ivLifeThree.image=[UIImage imageNamed:@"lostHeart.png"];
            break;
        case 1:
            ivLifeTwo.image=[UIImage imageNamed:@"lostHeart.png"];
            break;
         case 0:
            ivLifeOne.image=[UIImage imageNamed:@"lostHeart.png"];
            break;
        default:
            break;
    }
}


@end
