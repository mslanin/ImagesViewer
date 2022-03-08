//
//  NetworkService.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//

import Foundation

public final class NetworkService {
    
    public init() {}
    public let configuration: URLSessionConfiguration = .default
    public lazy var urlSession: URLSession = .init(configuration: configuration)
    public var cache: [URL: Data] = [:]
    
    public func fetchData(from url: URL,
                          completion: @escaping (Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let request: URLRequest = .init(url: url)
            
            if let data = self.cache[url] {
                completion(.success(data))
            }
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    completion(.failure(.unableToComplete))
                }
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                          completion(.failure(.invalidResponse))
                     return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                self.cache[url] = data
                completion(.success(data))
            }
            
            task.resume()
        }
    }
}

public enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalid URL"
        case .unableToComplete:
            return "Unable to complete your request"
        case .invalidResponse:
            return "Invalid response from the server"
        case .invalidData:
            return "The data received from the server was invalid"
        }
    }
}
