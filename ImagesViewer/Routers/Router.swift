//
//  Router.swift
//  ImagesViewer
//
//  Created by Михаил on 06.03.2022.
//

import Foundation
import UIKit

public enum Route {
    case fullSizeImageController(ImageDataModel?)
}

public class Router {
    
    private static func inizializeViewController(_ controller: Route) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        switch controller {
        case .fullSizeImageController(let imageData):
            guard let vc = storyboard.instantiateViewController(withIdentifier: "FullSizeImageController") as? FullSizeImageViewController else {
                 return nil
            }
            vc.model = imageData
            return vc
        }
    }
    
    static func navigateTo(_ route: Route, from viewController: UIViewController? = nil) {
        guard let navigationController = viewController?.navigationController ?? rootNavigationController,
              let targetVC = Router.inizializeViewController(route) else {
             return
        }
        
        navigationController.pushViewController(targetVC, animated: true)
    }
    
    static func popTo(_ route: Route, from viewController: UIViewController? = nil) {
        guard let navigationController = viewController?.navigationController ?? rootNavigationController,
              let targetVC = Router.inizializeViewController(route) else {
             return
        }
        
        navigationController.popToViewController(targetVC, animated: true)
    }
    
    private static var rootNavigationController: UINavigationController? {
        let window = UIApplication.shared.delegate?.window
        return window??.rootViewController as? UINavigationController
    }
}
