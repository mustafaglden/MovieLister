//
//  ImageUploadService.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation
import UIKit

final class ImageUploadService {
    static let shared = ImageUploadService()
    
    func uploadImage(base64String: String, prompt: String, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
        var endpoint = APIEndpoint.uploadImage()
        endpoint.body = try? JSONSerialization.data(withJSONObject: [
            "prompt": prompt,
            "base64str": base64String,
            "inputImage": false
        ])
        
        NetworkManager.shared.request(endpoint: endpoint, completion: completion)
    }
}
