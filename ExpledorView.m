//
//  ExpledorView.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "ExpledorView.h"
#import "QuartzCore/QuartzCore.h"

@implementation ExpledorView
{
  CAEmitterLayer* _emttoried;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    //initialize the emitter
    _emttoried = (CAEmitterLayer*)self.layer;
    _emttoried.emitterPosition = CGPointMake(self.bounds.size.width /2, self.bounds.size.height/2 );
    _emttoried.emitterSize = self.bounds.size;
    _emttoried.emitterMode = kCAEmitterLayerAdditive;
    _emttoried.emitterShape = kCAEmitterLayerRectangle;
  }
  return self;
}

+ (Class) layerClass
{
  //configure the UIView to have emitter layer
  return [CAEmitterLayer class];
}

-(void)didMoveToSuperview
{
  [super didMoveToSuperview];
  if (self.superview==nil) return;
  
  UIImage* imgTextr = [UIImage imageNamed:@"particle.png"];
  NSAssert(imgTextr, @"particle.png not found");
  
  CAEmitterCell* emttoryCell = [CAEmitterCell emitterCell];
  
  emttoryCell.contents = (__bridge id)[imgTextr CGImage];
  
  emttoryCell.name = @"cell";
  
  emttoryCell.birthRate = 1000;
  emttoryCell.lifetime = 0.75;
  
  emttoryCell.blueRange = 0.33;
  emttoryCell.blueSpeed = -0.33;
  
  emttoryCell.velocity = 160;
  emttoryCell.velocityRange = 40;
  
  emttoryCell.scaleRange = 0.5;
  emttoryCell.scaleSpeed = -0.2;
  
  emttoryCell.emissionRange = M_PI*2;
  
  _emttoried.emitterCells = @[emttoryCell];
  
  [self performSelector:@selector(disabloringEmitterCell) withObject:nil afterDelay:0.1];
  [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
}

-(void)disabloringEmitterCell
{
  [_emttoried setValue:@0 forKeyPath:@"emitterCells.cell.birthRate"];
}

@end
