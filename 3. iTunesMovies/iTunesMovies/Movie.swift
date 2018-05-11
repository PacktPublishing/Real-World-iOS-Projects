//
//  Movie.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let artistName: String
    let name: String
    let kind: String
    let url: URL
    let copyright: String?
    let identifier: String
    let artwork: URL
    let releaseDate: Date
    let genres: [Genre]

    var genreDescription: String {
        return (genres.map({ (genre) in
            genre.name
        })).joined(separator: ", ")
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    struct Genre: Codable {
        let name: String
        let url: URL
        let identifier: String

        enum CodingKeys: String, CodingKey {
            case name, url
            case identifier = "genreId"
        }
    }

    enum CodingKeys: String, CodingKey {
        case artistName, name, kind, url, copyright, genres, releaseDate
        case identifier = "id"
        case artwork = "artworkUrl100"
    }
}
