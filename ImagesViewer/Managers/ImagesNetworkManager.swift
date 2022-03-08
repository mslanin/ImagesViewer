//
//  ImagesNetworkManager.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//
//

import Foundation

protocol ImageNetworkManagerProtocol {
    func fetchImageData(_ page: Int, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

public final class ImageNetworkManager: ImageNetworkManagerProtocol {
    
    let networkingService = NetworkService()

    func fetchImageData(_ page: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let category = "animals"
        let imageType = "photo"
        let imagePerPage = 5
        let imagePath = Constants.serverPath + Constants.serverAuth + "&page=\(page)" + "&category=\(category)" + "&image_type=\(imageType)" + "&per_page=\(imagePerPage)"
        
        guard let url = URL(string: imagePath) else {
             return
        }
        
        networkingService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
