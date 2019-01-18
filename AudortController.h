//
//  AudortController.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudortController : NSObject

-(void)playingEffect:(NSString*)name;
-(void)previousloadAudioEffects:(NSArray*)effectFileNames;

@end
