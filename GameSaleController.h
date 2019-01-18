//
//  GameSaleController.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Levoler.h"
#import "TiloryView.h"
#import "GamorData.h"
#import "AudortController.h"

typedef void (^CallbackBlock)();

@interface GameSaleController : NSObject <TileDragDelegateProtocol>

//the view to add game elements to
@property (weak, nonatomic) UIView* vGame;

//the current Levoler
@property (strong, nonatomic) Levoler* levelor;

@property (strong, nonatomic) GamorData* gData;

@property (strong, nonatomic) AudortController* audtController;

@property (strong, nonatomic) CallbackBlock onAgramSled;

@property(strong,nonatomic ) CallbackBlock wrongAgram;

@property(strong,nonatomic ) CallbackBlock getAnswAgram;

@property (strong, nonatomic) UIButton* bttunHelp;

@property (strong,nonatomic)UIButton *getAnswsBttn;

-(void)dealloryWithNum:(int)num;

-(void)actionADviewHintment;

@end
