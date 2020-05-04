//
//  AudioAPI.swift
//  Muter
//
//  Created by Hua Duong Tran on 30.04.20.
//  Copyright © 2020 Hua Duong Tran. All rights reserved.
//

import Foundation
import AudioToolbox
import CoreAudio

/// WIP, this will replace AudioAPI in the future.
public struct AudioApiSwift {
    public static let shared = AudioApiSwift()

    private init() { }

//    func getDefaultInputDevice() -> AudioDeviceID {
//        var defaultDevice = kAudioObjectUnknown;
//        var defaultOutputDeviceIDSize = UInt32(MemoryLayout.size(ofValue: kAudioObjectSystemObject))
//        var defaultInputDevicePropertyAddress = AudioObjectPropertyAddress(
//            mSelector: kAudioHardwarePropertyDefaultInputDevice,
//            mScope: kAudioObjectPropertyScopeGlobal,
//            mElement: kAudioObjectPropertyElementMaster
//        )
//
//        let audioObjectStatus = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
//                &defaultInputDevicePropertyAddress, 0, nil, &defaultOutputDeviceIDSize, &defaultDevice)
//
//        return defaultDevice
//    }

    private func getAudioObject(audioObject: AudioObjectID, property: AudioObjectPropertyAddress, dataSize: UInt32, data: () -> ()) {
//
//        var defaultOutputDeviceID = AudioDeviceID(0)
//        var defaultOutputDeviceIDSize = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))
//
//        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
//            mSelector: kAudioHardwarePropertyDefaultInputDevice,
//            mScope: kAudioObjectPropertyScopeGlobal,
//            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
//
//        let status1 = AudioObjectGetPropertyData(
//            AudioObjectID(kAudioObjectSystemObject),
//            &getDefaultOutputDevicePropertyAddress,
//            0,
//            nil,
//            &defaultOutputDeviceIDSize,
//            &defaultOutputDeviceID)
//        var volume = Float32(0.0) // 0.0 ... 1.0
//        var volumeSize = UInt32(MemoryLayout.size(ofValue: volume))
//
//        var volumePropertyAddress = AudioObjectPropertyAddress(
//            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
//            mScope: kAudioDevicePropertyScopeInput,
//            mElement: kAudioObjectPropertyElementMaster)
//
//        let status2 = AudioObjectSetPropertyData(
//            defaultOutputDeviceID,
//            &volumePropertyAddress,
//            0,
//            nil,
//            volumeSize,
//            &volume)
    }
}
