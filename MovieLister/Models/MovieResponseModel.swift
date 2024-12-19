//
//  MovieResponseModel.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//


struct MovieResponseModel: Decodable {
    let page: Int
    let results: [MovieModel]
    let totalPages: Int
    let totalResults : Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages  = "total_pages"
        case totalResults = "total_results"
    }
}
