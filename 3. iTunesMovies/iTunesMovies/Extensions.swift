//
//  Extensions.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static var activityIndicatorButton: UIBarButtonItem {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.sizeToFit()
        spinner.startAnimating()
        return UIBarButtonItem(customView: spinner)
    }
}
