//
//  Constants.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//

import Foundation

enum Constants {
    static let serverPath = "https://pixabay.com/api/"
    static var serverAuth: String {
        let apiKey = "25998496-4570782303a9528e8dcaf2948"
        
        return "?key=\(apiKey)"
    }
}
