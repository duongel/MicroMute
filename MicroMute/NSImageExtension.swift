//
//  NSImageExtension.swift
//  Muter
//
//  Created by Hua Duong Tran on 01.05.20.
//  Copyright © 2020 Hua Duong Tran. All rights reserved.
//

import Cocoa


extension NSImage {
    /// Creates a copy with the given tint color.
    /// - Parameter tintColor: The tint color to set.
    /// - Returns: The tinted copy of the calling instance.
    func image(with tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }

        let image = self.copy() as! NSImage
        image.lockFocus()

        tintColor.set()

        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceIn)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}
