//
//  UIImage + Ext.swift
//  ImagesViewer
//
//  Created by Михаил on 06.03.2022.
//

import UIKit

extension UIImage {

    func getExifData() -> NSDictionary? {
        var exifData: NSDictionary?
        if let data = self.jpegData(compressionQuality: 1.0) {
            data.withUnsafeBytes {
                let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.count),
                    let source = CGImageSourceCreateWithData(cfData, nil) {
                    exifData = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
                }
            }
        }
        return exifData
    }
}
