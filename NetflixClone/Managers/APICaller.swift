//
//  APICaller.swift
//  NetflixClone
//
//  Created by Maks Kokos on 30.10.2022.
//

import Foundation

struct Constants {
    static let apiKey = "2f842c7def21b4e1d93b4c79d97c891a"
    static let baseURL = "https://api.themoviedb.org"
    static let youTubeApiKey = "AIzaSyDDD3IPcAPBSttyAczYQ8S3G1-wcv7tZzY"
    static let youTubeSearchBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.apiKey)&language=en-US&page=1") else {return}
        createDataTask(url: url, completion: completion)
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.apiKey)&language=en-US&page=1") else {return}
        createDataTask(url: url, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.apiKey)&language=en-US&page=1") else { return }
        createDataTask(url: url, completion: completion)
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1") else { return }
        createDataTask(url: url, completion: completion)
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.apiKey)&language=en-US&page=1") else { return }
        createDataTask(url: url, completion: completion)
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        createDataTask(url: url, completion: completion)
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.apiKey)&query=\(query)") else { return }
            createDataTask(url: url, completion: completion)
    }
    
    func getMoviesFromYouTube(with query: String, completion: @escaping (Result<Video, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youTubeSearchBaseUrl)q=\(query)&key=\(Constants.youTubeApiKey)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return  }
            do {
                let results = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                print(results)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()

    }
    
    private func createDataTask(url: URL, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return  }
            do {
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }

}
 
