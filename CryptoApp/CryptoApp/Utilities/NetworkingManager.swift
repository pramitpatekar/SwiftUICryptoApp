//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Ref on 12/08/24.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): "Bad Response from URL: \(url)"
            case .unknown: "Unknown Error occured"
                
            }
        }
    }
    
    //by making this a static func we never need to initialize the class
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        //    .subscribe(on: DispatchQueue.global(qos: .background))              this step is not required because the dataTaskPublisher goes to the background thread automatically
        	
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)                            // if the response from the server fails it retries it 3 times so that we can receive the downloaded data
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case.finished:
            break
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
}
