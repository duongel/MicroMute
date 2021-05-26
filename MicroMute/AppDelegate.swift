//
//  AppDelegate.swift
//  Muter
//
//  Created by Hua Duong Tran.
//  Copyright © 2020 Hua Duong Tran. All rights reserved.
//

import Cocoa
import Magnet
import AudioToolbox
import CoreAudio

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu?
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AudioAPI.shared()?.delegate = self;
        setupHotkey()
        setupIcon()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let menu = menu {
            statusItem?.menu = menu
        }
    }

// MARK: - Setup
    
    /// Sets the following keys as hotkey to toggle muted/unmuted state: CMD+option+m
    private func setupHotkey() {
        if let keyCombo = KeyCombo(QWERTYKeyCode: 46, cocoaModifiers: [.command, .option]) {
            let hotKey = HotKey(identifier: "OptionM", keyCombo: keyCombo, target: self, action: #selector(toggleMute))
            hotKey.register()
        }
    }
    
    /// Sets the statusbar icon based on the current state. If muted, a red icon with crossed out microphone will be set. Otherwise, the default black microphone icon.
    private func setupIcon() {
        let isMuted = AudioAPI.shared()?.isMuted() ?? false
        let imageName = isMuted ? "muted" : "unmuted"
        var itemImage = NSImage(named: imageName)
        itemImage?.isTemplate = true

        if isMuted {
            itemImage = itemImage?.image(with: .red)
        }

        statusItem?.button?.image = itemImage
    }

    /// Toggles between muted and unmuted state.
    @objc func toggleMute() {
        let isMuted = AudioAPI.shared()?.isMuted() ?? false

        AudioAPI.shared()?.setMuted(!isMuted)
    }

    @IBAction func menuTogglePressed(_ sender: NSMenuItem) {
        toggleMute()
    }
}

extension AppDelegate: AudioAPIDelegate {
    func volumeChanged() {
        setupIcon()
    }
}
