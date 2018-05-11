//
//  DetailViewController.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    private(set) var movie: Movie?
    private(set) var imageCache: ImageCache?

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleCell: UITableViewCell?
    @IBOutlet weak var directorCell: UITableViewCell?
    @IBOutlet weak var releaseDateCell: UITableViewCell?
    @IBOutlet weak var genresCell: UITableViewCell?
    @IBOutlet weak var copyrightCell: UITableViewCell?
    @IBOutlet weak var moreInfoCell: UITableViewCell?

    func configureForPhoto(movie: Movie, imageCache: ImageCache) {
        self.movie = movie
        self.imageCache = imageCache
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie, let imageCache = imageCache {
            title = movie.name
            titleCell?.detailTextLabel?.text = movie.name
            directorCell?.detailTextLabel?.text = movie.artistName
            releaseDateCell?.detailTextLabel?.text = DetailViewController.dateFormatter.string(from: movie.releaseDate)
            genresCell?.detailTextLabel?.text = movie.genreDescription
            copyrightCell?.detailTextLabel?.text = movie.copyright
            imageCache.image(with: movie.artwork) { (_, image, _) in
                self.imageView?.image = image
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = movie, let moreInfoCell = moreInfoCell, indexPath == tableView.indexPath(for: moreInfoCell),         UIApplication.shared.canOpenURL(movie.url) {
            UIApplication.shared.open(movie.url, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

