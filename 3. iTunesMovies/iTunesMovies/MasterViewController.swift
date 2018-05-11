//
//  MasterViewController.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {

    let dataSource = MovieDataSource(count: 200)
    private let imageCache = ImageCache()

    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(startLoading), for: .valueChanged)
        return refresh
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addSubview(refreshControl)
        startLoading()
    }

    @objc private func startLoading() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.activityIndicatorButton
        dataSource?.fetch(completion: { (error) in
            self.stopLoading()
        })
    }

    private func stopLoading() {
        navigationItem.setRightBarButton(nil, animated: true)
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let dataSource = dataSource,
            let navigationController = segue.destination as? UINavigationController,
            let detail = navigationController.topViewController as? DetailViewController,
            let indexPath = collectionView?.indexPathsForSelectedItems?.first
        {
            detail.configureForPhoto(movie: dataSource.movies[indexPath.item], imageCache: imageCache)
        }
    }
}

extension MasterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let artworkSize = CGSize(width: 133, height: 200)
        let count = trunc(collectionView.frame.width / artworkSize.width) + 1
        let width = collectionView.frame.width / count
        let aspect = artworkSize.width / artworkSize.height
        return CGSize(width: width, height: width / aspect)
    }

}

extension MasterViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let dataSource = dataSource, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell {
            let movie = dataSource.movies[indexPath.item]
            cell.configure(with: movie, imageCache: imageCache)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.movies.count
        } else {
            return 0
        }
    }

}

