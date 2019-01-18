//
//  CountoryLabelView.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountoryLabelView : UILabel

@property (assign, nonatomic) int countVle;

+(instancetype)lblyWithFontor:(UIFont*)font frame:(CGRect)r andValue:(int)v;

-(void)countorTo:(int)to withDuration:(float)tDur;

@end
