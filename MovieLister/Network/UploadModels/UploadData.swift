//
//  UploadData.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation

struct UploadData: Decodable {
    let base64str: String
    let title: String
}
