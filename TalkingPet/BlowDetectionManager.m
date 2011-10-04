//
//  CDBlowDetectionManager.m
//  DragonsBreath
//
//  Created by Chris Lueking on 6/28/11.
//  Copyright 2011 Nomad Games, LLC. All rights reserved.
//
//created as a simple tool for monitoring blow detection.  
//Baised on this tutorial - http://www.mobileorchard.com/tutorial-detecting-when-a-user-blows-into-the-mic/
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "BlowDetectionManager.h"

@implementation BlowDetectionManager

//creates the singelton
static BlowDetectionManager *sharedManager = nil;

+(BlowDetectionManager*) sharedManager {
    @synchronized(self) {
		if (sharedManager == nil) {
            sharedManager = [[BlowDetectionManager alloc] init];
        }
        
	}
    return sharedManager;
}

-(id)init{
    if((self=[super init])) {
        //file set to /dev/null so that it will simply dump and only monitor
		NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];

        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                  nil];
        NSError *error;
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        
        _threshold = .9;
	}
	return self;
}

//to start listening
-(void)startListening{
    if (_recorder) {
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder record];
    }
}

//to stop listening
-(void)stopListening{
    [_recorder stop];
}

//a debugging report
-(void)logReport{
    NSLog(@"Average input in db: %f Peak input in db: %f - Power: %f Threshold Level: %f", [_recorder averagePowerForChannel:0], [_recorder peakPowerForChannel:0], _convertedPower * 100, _threshLvl);
}

//run this in your update method
-(void)listen{
    //experimental values at attempted power monitoring
    //const double ALPHA = 0.05;
    //_lowPassResults = ALPHA * _threshLvl + (1.0 - ALPHA) * _lowPassResults;
    //NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
    
    [_recorder updateMeters];
    _threshLvl = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    _avgMeter = pow(10, (0.05 * [_recorder averagePowerForChannel:0]));
    float avgAmbient = -35;
    _convertedPower = ((([_recorder peakPowerForChannel:0] - avgAmbient) * (1 - 0)) / (0. - avgAmbient)) + 0;
    if (_convertedPower < 0) {
        _convertedPower = 0;
    }    
//    if (_threshLvl > _threshold) {
//        [self logReport];
//    }
    
    //NSLog(@"Peak sound level: %f", _threshLvl);
}

//returns is a user is blowing into the mic
-(BOOL)userIsBlowing{
    if (_threshLvl > _threshold) {
        return YES;
    } else {
        return NO;
    }
}

//returns the blowing power level
//**experimental** seems to either return a very low number or 1(full blast)
//needs to be tweaked to return middle powers
-(float)power{
    if (_threshLvl > _threshold) {
        return _convertedPower;
    } else {
        return 0;
    }
}

@end