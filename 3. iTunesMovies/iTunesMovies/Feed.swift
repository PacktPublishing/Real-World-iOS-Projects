//
//  Feed.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import Foundation

struct Feed: Codable {
    let title: String
    let results: [Movie]
}

