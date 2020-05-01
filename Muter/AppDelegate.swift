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
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let menu = menu {
            statusItem?.menu = menu
        }
    }

}

