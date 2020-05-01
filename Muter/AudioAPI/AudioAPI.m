//
//  AudioAPI.m
//  Muter
//
//  Created by Hua Duong Tran on 01.05.20.
//  Copyright © 2020 Hua Duong Tran. All rights reserved.
//

#import "AudioAPI.h"
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudio.h>

@implementation AudioAPI

AudioObjectPropertyListenerBlock onDefaultInputDeviceChange = NULL;
AudioObjectPropertyListenerBlock onAudioDeviceMuteChange = NULL;
AudioDeviceID currentAudioDeviceID = kAudioObjectUnknown;

- (AudioObjectPropertyAddress) mutePropertyAddress {
    AudioObjectPropertyAddress propertyAddress = {
        kAudioDevicePropertyMute,
        kAudioDevicePropertyScopeInput,
        kAudioObjectPropertyElementMaster
    };

    return propertyAddress;
}

- (AudioObjectPropertyAddress) defaultInputDevicePropertyAddress {
    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwarePropertyDefaultInputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    return propertyAddress;
}


#pragma mark - Initialisation

static AudioAPI *sharedAudio = nil;

+ (AudioAPI *)shared {
    @synchronized(self) {
        if (sharedAudio == nil) {
            sharedAudio = [[self alloc] init];
            onDefaultInputDeviceChange = ^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress * _Nonnull inAddresses) {
                BOOL muted = false;
                BOOL setMuted = false;
                
                if (currentAudioDeviceID != kAudioObjectUnknown) {
                    setMuted = true;
                    muted = [sharedAudio getInputDeviceMute:currentAudioDeviceID];
                    
                    [sharedAudio unlistenInputDevice:currentAudioDeviceID];
                }
                
                [sharedAudio setDefaultInputDeviceAsCurrentAndListen];
                
                if (setMuted) {
                    [sharedAudio setInputDevice:currentAudioDeviceID mute:muted];
                }
            };
            
            onAudioDeviceMuteChange = ^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress * _Nonnull inAddresses) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sharedAudio notifyDelegate];
                });
            };
            [sharedAudio listenInputDevices];
        }
    }
    return sharedAudio;
}


- (void) listenInputDevices {
    AudioObjectPropertyAddress propertyAddress = [self defaultInputDevicePropertyAddress];
    
    OSStatus error = AudioObjectAddPropertyListenerBlock(kAudioObjectSystemObject, &propertyAddress, NULL, onDefaultInputDeviceChange);
    if (error != noErr) {
        NSLog(@"Cannot listen to change of default device. Error: %d", error);
    }
    
    [self setDefaultInputDeviceAsCurrentAndListen];
}

- (void) setDefaultInputDeviceAsCurrentAndListen {
    currentAudioDeviceID = [self getDefaultInputDevice];
    
    if (currentAudioDeviceID != kAudioObjectUnknown) {
        OSStatus error = [self listenInputDevice:currentAudioDeviceID];
        if (error != noErr) {
            currentAudioDeviceID = kAudioObjectUnknown;
        } else {
            NSLog(@"Listening to device: 0x%0x", currentAudioDeviceID);
        }
    }
}

- (OSStatus) listenInputDevice:(AudioDeviceID)deviceID {
    AudioObjectPropertyAddress muteAddress = [self mutePropertyAddress];
    
    OSStatus error = AudioObjectAddPropertyListenerBlock(deviceID, &muteAddress, NULL, onAudioDeviceMuteChange);
    if (error != noErr) {
        NSLog(@"Cannot listen to mute change of device: 0x%0x. Error: %d", deviceID, error);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyDelegate];
    });
    
    return error;
}

- (void) unlistenInputDevice:(AudioDeviceID)deviceID {
    AudioObjectPropertyAddress muteAddress = [self mutePropertyAddress];
    
    OSStatus error = AudioObjectRemovePropertyListenerBlock(deviceID, &muteAddress, NULL, onAudioDeviceMuteChange);
    if (error != noErr) {
        NSLog(@"Can't unlisten mute change of device: 0x%0x. Error: %d", deviceID, error);
    }
    
    [self setInputDevice:deviceID mute:false];
}


#pragma mark - Getter / Setter

- (AudioDeviceID) getDefaultInputDevice {
    AudioDeviceID defaultDevice = kAudioObjectUnknown;
    AudioObjectPropertyAddress address = [self defaultInputDevicePropertyAddress];
    
    [self getAudioObject:kAudioObjectSystemObject property:address dataSize:sizeof(AudioDeviceID) data:&defaultDevice];
    
    return defaultDevice;
}

- (void) setInputDevice:(AudioDeviceID)deviceID mute:(BOOL)mute {
    UInt32 value = mute ? 1 : 0;
    AudioObjectPropertyAddress propertyAddress = [self mutePropertyAddress];
    
    BOOL s = [self setAudioObject:deviceID property:propertyAddress dataSize:sizeof(value) data:&value];
    
    if (s) {
        AudioObjectShow(deviceID);
    }
}

- (BOOL) getAudioObject:(AudioObjectID)audioObjectID
                       property:(AudioObjectPropertyAddress)propertyAddress
                       dataSize:(UInt32)dataSize
                           data:(void *)data
{
    if (!AudioObjectHasProperty(audioObjectID, &propertyAddress) ) {
        NSLog(@"No property for audioObject 0x%0x", audioObjectID);
        return false;
    }
    
    OSStatus theError = AudioObjectGetPropertyData(audioObjectID, &propertyAddress, 0, NULL, &dataSize, data);
    if (theError != noErr)    {
        NSLog(@"Unable to read property for audioObject 0x%0x", audioObjectID);
        return false;
    }
    
    return true;
}

- (BOOL) setAudioObject:(AudioObjectID)audioObjectID
               property:(AudioObjectPropertyAddress)propertyAddress
               dataSize:(UInt32)dataSize
                   data:(const void *)data
{
    if (!AudioObjectHasProperty(audioObjectID, &propertyAddress) ) {
        NSLog(@"No property for audioObject 0x%0x", audioObjectID);
        return false;
    }
    
    Boolean settable;
    OSStatus theError = AudioObjectIsPropertySettable(audioObjectID, &propertyAddress, &settable);
    if (theError != noErr || !settable) {
        NSLog(@"The property of audioObject 0x%0x cannot be set", audioObjectID);
        return false;
    }
    
    //now read the property and correct it, if outside [0...1]
    theError = AudioObjectSetPropertyData(audioObjectID, &propertyAddress, 0, NULL, dataSize, data);
    if (theError != noErr) {
        NSLog(@"Unable to set property for audioObject 0x%0x", audioObjectID);
        return false;
    }
    
    return true;
}

- (BOOL) getInputDeviceMute:(AudioDeviceID)deviceID {
    AudioObjectPropertyAddress propertyAddress = [self mutePropertyAddress];
    UInt32 data;
    
    BOOL success = [self getAudioObject:deviceID property:propertyAddress dataSize:sizeof(data) data:&data];
    return success ? data == 1 : false;
}


#pragma mark - Delegate

- (void) notifyDelegate {
    if (self.delegate && [self.delegate respondsToSelector: @selector(volumeChanged)]) {
        [self.delegate volumeChanged];
    }
}


#pragma mark - Public api


- (BOOL)isMuted {
    if (currentAudioDeviceID == kAudioObjectUnknown) {
        NSLog(@"currentAudioDeviceID is kAudioObjectUnknown!");
        return NO;
    }
    
    BOOL isMuted = [self getInputDeviceMute:currentAudioDeviceID];
    return isMuted;
}

- (void)setMuted:(BOOL)muted {
    [self setInputDevice:currentAudioDeviceID mute:muted];
}

@end
