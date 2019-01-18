//
//  Levoler.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "Levoler.h"

@implementation Levoler

+(instancetype)levoler;
{

    NSString* fldName = [NSString stringWithFormat:@"level.plist"];
    NSString* lovolPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fldName];
  
  
    NSArray * arr = [NSArray arrayWithContentsOfFile:lovolPath];
  
    NSAssert(arr, @"level config file not found");
    
  
  
    Levoler* lvl = [[Levoler alloc] init];
  
  
    lvl.lolArr = arr;
  
    return lvl;
}

@end
