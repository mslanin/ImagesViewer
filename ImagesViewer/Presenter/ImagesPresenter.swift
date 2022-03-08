//
//  ImagesPresenter.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesPresenterProtocol {
    func getImagesData(completion: (() -> Void)?)
}

final class ImagesPresenter: ImagesPresenterProtocol {
    
    private var view: ImagesViewable
    private var networkService: NetworkService
    private var imageNetworkManager: ImageNetworkManager
    private var page: Int = 1
    
    func getImagesData(completion: (() -> Void)?) {
        imageNetworkManager.fetchImageData(page) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(
                        ImageResponse.self,
                        from: data
                    )
                    RealmService().saveToDatabase(response.hits)
                    self?.page += 1
                } catch {
                    print(NetworkError.invalidData.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.view.reloadData()
            completion?()
        }
    }
    
    init(view: ImagesViewable,
         networkService: NetworkService,
         imageNetworkManager: ImageNetworkManager) {
        self.view = view
        self.networkService = networkService
        self.imageNetworkManager = imageNetworkManager
    }
}
