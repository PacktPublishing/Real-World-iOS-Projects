//
//  SplitViewController.swift
//  iTunesMovies
//
//  Created by Packt on 14.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredPrimaryColumnWidthFraction = 0.5
        preferredDisplayMode = .allVisible
        delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
    }
}
