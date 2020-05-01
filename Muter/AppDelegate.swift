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
        if let keyCombo = KeyCombo(keyCode: 46, cocoaModifiers: [.command, .option]) {
            let hotKey = HotKey(identifier: "OptionM", keyCombo: keyCombo, target: self, action: #selector(toggleMute))
            hotKey.register()
        }
    }

    private func setupIcon() {
        let imageName = "unmuted"
        var itemImage = NSImage(named: imageName)
        itemImage?.isTemplate = true

        statusItem?.button?.image = itemImage
    }

    /// Toggles between mute and unmuted state.
    @objc func toggleMute() {
    }

    @IBAction func menuTogglePressed(_ sender: NSMenuItem) {
        toggleMute()
    }
}

