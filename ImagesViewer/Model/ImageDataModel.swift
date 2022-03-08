//
//  ImageModel.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//

import Foundation
import RealmSwift

struct ImageResponse: Codable {
    let total, totalHits: Int?
    let hits: [ImageDataModel]
}

public class ImageDataModel: Object, Codable {
    @objc dynamic public var id: Int
    @objc dynamic public var webformatURL: String
    @objc dynamic public var largeImageURL: String
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}

