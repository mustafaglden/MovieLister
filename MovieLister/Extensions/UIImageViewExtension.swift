//
//  UIImageViewExtension.swift
//  MovieLister
//
//  Created by Mustafa on 18.12.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
//    func resized(to size: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        defer { UIGraphicsEndImageContext() }
//        self.draw(in: CGRect(origin: .zero, size: size))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
}
