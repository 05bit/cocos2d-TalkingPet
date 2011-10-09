//
//  AudioEmitter.h
//  Aural
//
//  Created by Karl Stenerud on 2/19/11.
//
// Copyright 2011 Karl Stenerud
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Note: You are NOT required to make the license available from within your
// iOS application. Including it in your project is sufficient.
//
// Attribution is not required, but appreciated :)
//

#ifndef AURAL_AUDIOEMITTER_H
#define AURAL_AUDIOEMITTER_H

/*
 features:
 - pitch
 - tempo
 - playback rate
 - pan
 - mute
 - stereo
 - 3d positioning
 - streaming
 - playback position
 - metering
 - looping
 - notify on playback end
 - play at time
 - reverb
 - tremolo?
 - vibrato?
 
 purpose:
 - streaming
 - instant playback
 - looped playback
 - hardware acceleration
 
 data source:
 - memory buffer
 - stream
 */

namespace aural
{
    class AudioData;
    
    class AudioEmitter
    {
    public:
        virtual ~AudioEmitter() {};
        
        virtual AudioData* audioData() = 0;
        virtual void setAudioData(AudioData*const audioData) = 0;
        
        virtual bool paused() = 0;
        virtual void setPaused(const bool paused) = 0;
        
        virtual bool muted() = 0;
        virtual void setMuted(const bool muted) = 0;
        
        virtual float gain() = 0;
        virtual void setGain(const float gain) = 0;
        
        virtual float pan() = 0;
        virtual void setPan(const float pan) = 0;
        
        virtual float pitch() = 0;
        virtual void setPitch(const float pitch) = 0;
        
        virtual float playbackRate() = 0;
        virtual void setPlaybackRate(const float playbackRate) = 0;
        
        virtual void play() = 0;
        virtual void stop() = 0;
    };
}

#endif // AURAL_AUDIOEMITTER_H

