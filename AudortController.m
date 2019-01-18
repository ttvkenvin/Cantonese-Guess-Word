//
//  AudortController.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "AudortController.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudortController
{
  NSMutableDictionary* audio;
}

-(void)previousloadAudioEffects:(NSArray*)effectFileNames
{
  //initialize the effects array
  audio = [NSMutableDictionary dictionaryWithCapacity: effectFileNames.count];
  
  //loop over the filenames
  for (NSString* effect in effectFileNames) {
    
    //1 get the file path URL
    NSString* soundPthor = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: effect];
    NSURL* soundorURL = [NSURL fileURLWithPath: soundPthor];
    
    //2 load the file contents
    NSError* loadError = nil;
    AVAudioPlayer *avplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundorURL error: &loadError];
    NSAssert(loadError==nil, @"load sound failed");
    
    //3 prepare the play
    avplayer.numberOfLoops = 0;
    [avplayer prepareToPlay];
    
    //4 add to the array ivar
    audio[effect] = avplayer;
  }
}

- (void)playingEffect:(NSString*)name
{
  NSAssert(audio[name], @"effect not found");
  
  AVAudioPlayer* playor = (AVAudioPlayer*)audio[name];
  if (playor.isPlaying) {
    playor.currentTime = 0;
  } else {
    [playor play];
  }
}

@end
