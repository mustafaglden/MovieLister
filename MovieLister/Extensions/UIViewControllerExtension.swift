//
//  UIViewControllerExtension.swift
//  MovieLister
//
//  Created by Mustafa on 19.12.2024.
//

import UIKit

extension UIViewController {
    func showAlert(
        _ message: String,
        title: String = "error".localized,
        actionButtonTitle: String = "ok".localized,
        actionButtonHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionButtonTitle, style: .default) { _ in
            actionButtonHandler?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

