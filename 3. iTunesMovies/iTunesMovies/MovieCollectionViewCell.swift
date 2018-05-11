//
//  MovieCollectionViewCell.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView?
    private var movie: Movie?

    func configure(with movie: Movie, imageCache: ImageCache) {
        self.movie = movie
        imageCache.image(with: movie.artwork) { (url, image, error) in
            if let image = image, url == self.movie?.artwork {
                self.imageView?.image = image
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        movie = nil
    }

}
