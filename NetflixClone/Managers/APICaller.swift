//
//  APICaller.swift
//  NetflixClone
//
//  Created by Maks Kokos on 30.10.2022.
//

import Foundation

struct Constants {
    static let API_KEY = "2f842c7def21b4e1d93b4c79d97c891a"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return  }

            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results ))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
