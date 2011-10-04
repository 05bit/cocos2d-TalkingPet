//
//  AudioController.m
//  TalkingPet
//
//  Created by Alexey Kinyov on 10/4/11.
//  Copyright 2011 05Bit. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController

@synthesize recordedTmpFile;

- (void)initAudioController 
{
    //Instanciate an instance of the AVAudioSession object.
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    
    //Setup the audioSession for playback and record. 
    //We could just use record and then switch it to playback leter, but
    //since we are going to do both lets set it up once.
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    
    //Activate the session
    [audioSession setActive:YES error: &error];

    // Cocos Dension sound engine
    soundEngine = [[CDSoundEngine alloc] init];
    NSArray *defs = [NSArray arrayWithObjects: [NSNumber numberWithInt:1],nil]; 
    [soundEngine defineSourceGroups:defs];
}

- (void)unloadAudioController
{
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm removeItemAtURL:recordedTmpFile error:&error];
    [recorder dealloc];
    recorder = nil;
    [soundEngine release];
}

- (void)stopRecording
{   [recorder stop];
    [self play];
}

- (void)record
{
    NSLog(@"Record!");
    
    [[AVAudioSession sharedInstance] setCategory:
     AVAudioSessionCategoryPlayAndRecord error: nil];

    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"recording.caf"];
    self.recordedTmpFile = [NSURL fileURLWithPath:path];
    
    recorder = [[AVAudioRecorder alloc]
                initWithURL:recordedTmpFile
                settings:recordSetting error:&error];
 
    [recorder setDelegate:self];
    [recorder prepareToRecord];       
    [recorder record];
}

- (void)play
{
    NSLog(@"Play!");
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"recording.caf"];
    [soundEngine loadBuffer:0 filePath:filePath];
    [soundEngine playSound:0 sourceGroupId:0 pitch:1.0 pan:0.0 gain:1.0 loop:NO];
}

@end
