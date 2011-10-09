//
//  HelloWorldLayer.m
//  TalkingPet
//
//  Created by Alexey Kinyov on 10/4/11.
//  Copyright 05Bit 2011. All rights reserved.
//

#import "OALAudioSession.h"
#import "OALTools.h"

#import "HelloWorldLayer.h"

enum HelloWorldObjects {
    kPressTag = 1,
    kSaySomethingTag,
    kPlayingTag,
};

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		CCLabelTTF *labelPress = [CCLabelTTF
                                  labelWithString:@"Touch to start recording"
                                  fontName:@"Marker Felt" fontSize:64];

		CCLabelTTF *labelRecording = [CCLabelTTF
                                  labelWithString:@"Recording... Say something"
                                  fontName:@"Marker Felt" fontSize:64];
        
		CCLabelTTF *labelPlaying = [CCLabelTTF
                                      labelWithString:@"Playing..."
                                      fontName:@"Marker Felt" fontSize:64];


		CGSize size = [[CCDirector sharedDirector] winSize];
	
		labelPress.position =  ccp( size.width /2 , size.height/2 );
		labelRecording.position =  ccp( size.width /2 , size.height/2 );
        labelRecording.visible = NO;
        labelPlaying.position =  ccp( size.width /2 , size.height/2 );
        labelPlaying.visible = NO;
        
		[self addChild: labelPress z:0 tag:kPressTag];
		[self addChild: labelRecording z:0 tag:kSaySomethingTag];
		[self addChild: labelPlaying z:0 tag:kPlayingTag];
        
        isRecording = NO;
        currentLabel = labelPress;
        
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                            priority:0 swallowsTouches:YES];
        
        audioController = [[AudioController alloc] init];
        [audioController initAudioController];

        // Aural
        
        [OALAudioSession sharedInstance];
        environment = manager.newEnvironment();
        environment->setSampleRate(44100);
        emitter = environment->newEmitter();
	}
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Touch!");
    
    if (!isRecording) {
        isRecording = YES;
        [self switchLabel:kSaySomethingTag];
        [audioController record];
    } else {
        isRecording = NO;
        [self switchLabel:kPlayingTag];
        //[audioController stopRecording];
        
//        if (buffer) {
//            emitter->stop();
//            delete buffer;
//        }
        buffer = [KSAudioFile audioDataWithUrl:audioController.recordedTmpFile stereo:NO];
        emitter->setAudioData(buffer);
        emitter->setPitch(0.6);
        emitter->play();

    }
    
    return NO;
}

- (void)switchLabel:(NSUInteger)tag
{
    currentLabel.visible = NO;
    currentLabel = [self getChildByTag:tag];
    currentLabel.visible = YES;
}

- (void) dealloc
{
    [audioController unloadAudioController];
    [audioController release];
	[super dealloc];
}
@end
