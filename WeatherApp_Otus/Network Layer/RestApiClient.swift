//
//  RestApiClient.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 12.12.2023.
//

import Foundation

enum NetworkError: Error {
    
    case invalidMimeType
    case invalidStatusCode
    case invalidRequest
    case serverFailed
    case unknown
    case emptyData
    case underlying(_ error: Error)
    case invalidURL
}

final class RestApiClient {
    
    private let session: URLSession = .shared
    
    func performRequest(_ requestConvertable: URLRequestConvertable, completion: @escaping (Result<Data, Error>) -> Void) {
        let request: URLRequest

        do {
            request = try requestConvertable.asRequest()
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let error = self.validate(response: response) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyData))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
    
    private func validate(response: URLResponse?) -> Error? {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.unknown
        }
        
        guard httpResponse.mimeType == "application/json" else {
            return NetworkError.invalidMimeType
        }
        
        switch httpResponse.statusCode {
        case 100..<200, 300..<400:
            return NetworkError.invalidStatusCode
        case 400..<500:
            return NetworkError.invalidRequest
        case 500..<600:
            return NetworkError.serverFailed
        default:
            break
        }
        
        return nil
    }
    
}
