//
//  GamorData.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "GamorData.h"

@implementation GamorData

//custom setter - keep the score positive
-(void)setPoints:(int)points
{
  _points = MAX(points, 0);
}

@end
