//
//  MovieDataSource.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import Foundation

enum MovieDataSourceError: Error {
    case resultDataError, unknownError
}

protocol MovieDataSourceProtocol {
    var movies: [Movie] { get }
    func fetch(completion: @escaping (Error?) -> Void)
}

final class MovieDataSource: MovieDataSourceProtocol {

    private(set) var movies: [Movie] = [Movie]()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Movie.dateFormatter)
        return decoder
    }()
    let url: URL
    private let session = URLSession.shared

    init?(count: Int) {
        let string = "https://rss.itunes.apple.com/api/v1/us/movies/top-movies/all/\(count)/explicit.json"
        if let url = URL(string: string) {
            self.url = url
        } else {
            return nil
        }
    }

    private func processResult(data: Data?, response: URLResponse?, error: Error?) throws -> Feed
    {
        switch (data, response as? HTTPURLResponse, error) {
        case (.some(let data), .some(let response), .none) where response.statusCode == 200:
            if let feed = try decoder.decode([String: Feed].self, from: data)["feed"] {
                return feed
            } else {
                throw MovieDataSourceError.resultDataError
            }
        case (_, _, .some(let error)):
            throw error
        default:
            throw MovieDataSourceError.unknownError
        }
    }

    func fetch(completion: @escaping (Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            do {
                let result = try self.processResult(data: data, response: response, error: error)
                DispatchQueue.main.async {
                    self.movies = result.results
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }


}









