//
//  RealmService.swift
//  ImagesViewer
//
//  Created by Михаил on 07.03.2022.
//

import Foundation
import RealmSwift

public class RealmService {
    
    private let realm = try! Realm()
    
    func saveToDatabase(_ model: [ImageDataModel]) {
        do {
            try! self.realm.write {
                self.realm.add(model, update: .all)
            }
        }
    }
    
    func loadFromDatabase() -> [ImageDataModel] {
        let model = realm.objects(ImageDataModel.self)
        return Array(model)
    }
}

