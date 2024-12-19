//
//  UploadResponse.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation

struct UploadResponse: Decodable {
    let result: Bool
    let responseMessage: String
    let data: UploadData?
}
