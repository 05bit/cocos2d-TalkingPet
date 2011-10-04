//
//  AudioController.h
//  TalkingPet
//
//  Created by Alexey Kinyov on 10/4/11.
//  Copyright 2011 05Bit. All rights reserved.
//

#import "cocos2d.h"
#import "CocosDenshion.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioController : NSObject <AVAudioRecorderDelegate>
{
    CDSoundEngine *soundEngine;
    AVAudioRecorder *recorder;
    NSURL *recordedTmpFile;
    NSError *error;
}

@property(nonatomic, retain) NSURL *recordedTmpFile;

- (void)initAudioController;
- (void)unloadAudioController;
- (void)play;
- (void)stopRecording;
- (void)record;

@end
