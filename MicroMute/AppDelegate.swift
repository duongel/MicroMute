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

    private func setupHotkey() {
        if let keyCombo = KeyCombo(QWERTYKeyCode: 46, cocoaModifiers: [.command, .option]) {
            let hotKey = HotKey(identifier: "OptionM", keyCombo: keyCombo, target: self, action: #selector(toggleMute))
            hotKey.register()
        }
    }

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

    /// Toggles between mute and unmuted state.
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
