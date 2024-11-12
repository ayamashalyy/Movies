//
//  Network Manger.swift
//  Movies
//
//  Created by aya on 17/09/2024.
//

import Foundation

struct Constants {
    static let API_KEY = "e77cee2c480a18ea32852987f2abcbc0"
    static let baseUrl = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDWITnA4OfaGkjSMdVuqdNvRMLoRX_vuMw"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}

class NetworkManager {
    
    static let shared = NetworkManager()
        
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failedTogetData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    // MARK: - API Methods
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSearchMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        fetchData(from: url) { (result: Result<TrendingTitlesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        
        fetchData(from: url) { (result: Result<YoutubeSearchResponse, Error>) in
            switch result {
            case .success(let response):
                if let firstVideo = response.items.first {
                    completion(.success(firstVideo))
                } else {
                    completion(.failure(APIError.failedTogetData))
                }
            case .failure(let error):
                print("Error fetching movie: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

}












































//class NetworkManager {
//
//    static let shared = NetworkManager()
//
//    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                completion(.success(results.results))
//                print(results.results[0].original_name)
//            } catch {
//                completion(.failure(APIError.failedTogetData))
//            }
//        }
//        task.resume()
//    }
//
//
//
//    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                completion(.success(results.results))
//                print(results.results[0].original_name)
//            } catch {
//                completion(.failure(APIError.failedTogetData))
//            }
//        }
//        task.resume()
//    }
//
//
//
//    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                completion(.success(results.results))
//                print(results.results[0].original_name)
//            } catch {
//                completion(.failure(APIError.failedTogetData))
//            }
//        }
//        task.resume()
//    }
//
//
//
//    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                completion(.success(results.results))
//                print(results.results[0].original_name)
//            } catch {
//                completion(.failure(APIError.failedTogetData))
//            }
//        }
//        task.resume()
//    }
//
//
//    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                completion(.success(results.results))
//                print(results.results[0].original_name)
//            } catch {
//                completion(.failure(APIError.failedTogetData))
//            }
//        }
//        task.resume()
//    }
//
//    func getSearchMovies(completion: @escaping (Result<[Title], Error>) -> Void){
//
//        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
//               let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//                   guard let data = data, error == nil else {
//                       return
//                   }
//
//                   do {
//                       let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                       completion(.success(results.results))
//
//                   } catch {
//                       completion(.failure(APIError.failedTogetData))
//                   }
//
//               }
//               task.resume()
//    }
//
//
//
//    func search(with query: String ,completion: @escaping (Result<[Title], Error>) -> Void){
//
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
//
//        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return }
//
//               let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//                   guard let data = data, error == nil else {
//                       return
//                   }
//
//                   do {
//                       let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
//                       completion(.success(results.results))
//
//                   } catch {
//                       completion(.failure(APIError.failedTogetData))
//                   }
//
//               }
//               task.resume()
//    }
//
//
//    func getMovie(with query: String ,completion: @escaping (Result<VideoElement, Error>) -> Void) {
//
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
//
//        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            do {
//                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
//                completion(.success(results.items[0]))
//
//
//            } catch {
//                completion(.failure(APIError.failedTogetData))
//            }
//        }
//        task.resume()
//    }
//
//
//}
