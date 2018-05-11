//
//  ImageCache.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

protocol ImageCacheProtocol {
    func image(with url: URL, completion: @escaping (URL, UIImage?, Error?) -> Void)
}

struct ImageCache: ImageCacheProtocol {

    private let cache = NSCache<NSURL, UIImage>()
    private let session = URLSession.shared

    func image(with url: URL, completion: @escaping (URL, UIImage?, Error?) -> Void) {
        if let image = cache.object(forKey: url as NSURL) {
            completion(url, image, nil)
        } else {
            session.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: url as NSURL)
                    DispatchQueue.main.async {
                        completion(url, image, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(url, nil, error)
                    }
                }
            }.resume()
        }
    }


}
