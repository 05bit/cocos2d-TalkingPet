//
//  HelloWorldLayer.h
//  TalkingPet
//
//  Created by Alexey Kinyov on 10/4/11.
//  Copyright 05Bit 2011. All rights reserved.
//

#import "cocos2d.h"
#import "Aural.h"
#import "IOSAudioManager.h"

#import "AudioController.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    BOOL isRecording;
    CCNode *currentLabel;
    AudioController *audioController;
    
    aural::IOSAudioManager manager;
	aural::AudioEnvironment *environment;
	aural::AudioData *buffer;
	aural::AudioEmitter *emitter;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

- (void)switchLabel:(NSUInteger)tag;

@end
