//
//  PressHUDVew.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopptWatchVew.h"
#import "CountoryLabelView.h"

@interface PressHUDVew : UIView

@property (strong, nonatomic) StopptWatchVew* vStopwth;
@property (strong, nonatomic) CountoryLabelView* gmPonts;
@property (strong, nonatomic) UIButton* bttunHelp;

+(instancetype)viwWithRectory:(CGRect)rect;

@end
