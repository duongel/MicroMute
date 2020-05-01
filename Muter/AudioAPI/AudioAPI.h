//
//  AudioAPI.h
//  Muter
//
//  Created by Hua Duong Tran on 01.05.20.
//  Copyright © 2020 Hua Duong Tran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AudioAPIDelegate <NSObject>

@required
- (void)volumeChanged;

@end


@interface AudioAPI : NSObject

@property (nonatomic, weak) id<AudioAPIDelegate> delegate;

/// The AudioAPI singleton.
+(AudioAPI *)shared;

/// Checks if the current system input is muted.
/// @return NO, if not muted or no currentAudioDeviceID is known. Otherwise, YES.
- (BOOL)isMuted;


/// Sets the system input to muted.
/// @param muted The state to set the system input to. YES to mute the system input. NO to unmute the system input.
- (void)setMuted: (BOOL)muted;

@end
