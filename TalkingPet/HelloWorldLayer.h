//
//  HelloWorldLayer.h
//  TalkingPet
//
//  Created by Alexey Kinyov on 10/4/11.
//  Copyright 05Bit 2011. All rights reserved.
//

#import "cocos2d.h"
#import "AudioController.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    BOOL isRecording;
    CCNode *currentLabel;
    AudioController *audioController;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
