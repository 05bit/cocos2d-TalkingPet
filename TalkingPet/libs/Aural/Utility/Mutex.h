//
//  AUCMutex.h
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

#ifndef AURAL_AUCMUTEX_H
#define AURAL_AUCMUTEX_H


#include <pthread.h>
#include "Logging.h"


namespace aural
{
    class Mutex
    {
    public:
        Mutex();
        ~Mutex();
        
        void lock();
        bool tryLock();
        void unlock();
        
    private:
        Mutex(const Mutex&);
        Mutex& operator=(const Mutex&);
    private:
        pthread_mutex_t mutex_;
    };


    class MutexLock
    {
    public:
        explicit MutexLock(Mutex& mutex);
        ~MutexLock();
    private:
        MutexLock(const MutexLock&);
        MutexLock& operator=(const MutexLock&);
    private:
        Mutex& mutex_;
    };


    class MutexTryLock
    {
    public:
        explicit MutexTryLock(Mutex& mutex);
        ~MutexTryLock();
        
        const bool locked;
        
    private:
        MutexTryLock(const MutexTryLock&);
        MutexTryLock& operator=(const MutexTryLock&);
    private:
        Mutex& mutex_;
    };

    
    inline Mutex::Mutex()
    {
        pthread_mutexattr_t attrib;
        
        if(0 != pthread_mutexattr_init(&attrib))
        {
            AURAL_LOG_ERROR("Could not initialize pthread attribute");
            return;
        }
        
        if(0 != pthread_mutexattr_settype(&attrib, PTHREAD_MUTEX_RECURSIVE))
        {
            AURAL_LOG_ERROR("Could not set pthread attribute");
            goto done;
        }
        
        if(0 != pthread_mutex_init(&mutex_, &attrib))
        {
            AURAL_LOG_ERROR("Could not initialize mutex");
        }
        
    done:
        pthread_mutexattr_destroy(&attrib);
    }
    
    inline Mutex::~Mutex()
    {
        if(0 != pthread_mutex_destroy(&mutex_))
        {
            AURAL_LOG_ERROR("Could not destroy mutex: mutex is busy");
        }
    }
    
    inline void Mutex::lock()
    {
        pthread_mutex_lock(&mutex_);
    }
    
    inline bool Mutex::tryLock()
    {
        return !pthread_mutex_trylock(&mutex_);
    }
    
    inline void Mutex::unlock()
    {
        pthread_mutex_unlock(&mutex_);
    }
    
    
    
    inline MutexLock::MutexLock(Mutex& mutex)
    : mutex_(mutex)
    {
        mutex_.lock();
    }
    
    inline MutexLock::~MutexLock()
    {
        mutex_.unlock();
    }

    

    inline MutexTryLock::MutexTryLock(Mutex& mutex)
    : mutex_(mutex)
    , locked(mutex_.tryLock())
    {
    }
    
    inline MutexTryLock::~MutexTryLock()
    {
        if(locked)
        {
            mutex_.unlock();
        }
    }
}

#endif // AURAL_AUCMUTEX_H
