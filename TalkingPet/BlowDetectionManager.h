//
//  CDBlowDetectionManager.h
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

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface BlowDetectionManager : NSObject {
    AVAudioRecorder *_recorder;
    //double _lowPassResults;
    double _threshold;
    double _threshLvl;
    double _avgMeter;
    float _convertedPower;
}

+(BlowDetectionManager*) sharedManager;

-(void)startListening;
-(void)listen;
-(float)power;
-(void)stopListening;
-(BOOL)userIsBlowing;

@end