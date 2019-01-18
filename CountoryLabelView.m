//
//  CountoryLabelView.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "CountoryLabelView.h"

@implementation CountoryLabelView
{
  int endVlu;
  double deltory;
}

//create an instance of the counter label
+(instancetype)lblyWithFontor:(UIFont*)font frame:(CGRect)r andValue:(int)v
{
  CountoryLabelView* lbCount = [[CountoryLabelView alloc] initWithFrame:r];
  if (lbCount!=nil) {
    //initialization
    lbCount.backgroundColor = [UIColor clearColor];
    lbCount.font = font;
    lbCount.countVle = v;
  }
  return lbCount;
}

//update the label's text
- (void)setCountVle:(int)countVle{
  _countVle = countVle;
  self.text = [NSString stringWithFormat:@" %i", self.countVle];
}

//increment/decrement method
-(void)updateValueBy:(NSNumber*)valueDelta
{
  // update the property
  self.countVle += [valueDelta intValue];
  
  // check for reaching the end value
  if ([valueDelta intValue] > 0) {
    if (self.countVle > endVlu) {
      self.countVle = endVlu;
      return;
    }
  } else {
    if (self.countVle < endVlu) {
      self.countVle = endVlu;
      return;
    }
  }
  
  // if not - do it again
  [self performSelector:@selector(updateValueBy:) withObject:valueDelta afterDelay:deltory];
}

//count to a given value
- (void)countorTo:(int)to withDuration:(float)tDur
{
  // detect the time for the animation
  deltory = tDur/(abs(to-self.countVle)+1);
  if (deltory < 0.05) deltory = 0.05;
  
  // set the end value
  endVlu = to;
  
  // cancel previous scheduled actions
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  
  // detect which way counting goes
  if (to-self.countVle>0) {
    //count up
    [self updateValueBy: @1];
  } else {
    //count down
    [self updateValueBy: @-1];
  }
}

@end
