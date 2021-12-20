//
//  NetworkHandler.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

class NetworkLayer {
    
    class func request<T: Codable>(router: Router, queryItems: [URLQueryItem] = [], completion: @escaping (Result<T, Error>) -> ()) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = queryItems
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        if router.method == "POST" {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in

            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard response != nil, let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch(let error) {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
}
