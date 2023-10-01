//
//  ActivityIndicatorView.swift
//  PodCast_Swift
//
//  Created by frizhub on 22/09/2023.
//

import UIKit

class LoaderView {
    
    // MARK: - Properties
    static let shared = LoaderView()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .darkGray
        ai.stopAnimating()
        ai.isHidden = true
        return ai
    }()
    
    func showLoader() -> UIActivityIndicatorView {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        return activityIndicatorView
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
    }
}
