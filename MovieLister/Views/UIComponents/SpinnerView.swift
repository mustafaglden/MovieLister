//
//  LoadingView.swift
//  MovieLister
//
//  Created by Mustafa on 18.12.2024.
//

import UIKit

final class SpinnerView {
    private var spinner: UIActivityIndicatorView?

    func show(on view: UIView) {
        if spinner == nil {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .blue
            spinner.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(spinner)
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            spinner.startAnimating()
            self.spinner = spinner
        }
    }

    func hide() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner = nil
    }
}
