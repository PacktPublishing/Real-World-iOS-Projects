//
//  Extensions.swift
//  WebBrowse
//
//  Created by Packt on 25.03.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(fixedSpaceWidth: CGFloat) {
        self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        width = fixedSpaceWidth
    }
}

extension UISearchController {
    convenience init(searchBarDelegate: UISearchBarDelegate) {
        self.init(searchResultsController: nil)

        dimsBackgroundDuringPresentation = false
        searchBar.returnKeyType = .go
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.keyboardType = .URL
        searchBar.autocapitalizationType = .none
        searchBar.delegate = searchBarDelegate
        searchBar.placeholder = NSLocalizedString("Enter URL", comment: "Search bar prompt")
    }
}

extension UserDefaults {
    var lastURL: URL? {
        get {
            return url(forKey: "url.last") ?? URL(string: "https://www.packtpub.com")
        }
        set {
            set(newValue, forKey: "url.last")
        }
    }
}
