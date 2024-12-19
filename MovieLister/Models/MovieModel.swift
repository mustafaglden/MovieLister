//
//  MovieModel.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

struct MovieModel: Decodable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let voteAverage: Double
    let voteCount: Int

    var posterURL: String {
        return "https://image.tmdb.org/t/p/w200\(posterPath)"
    }
    
    var isFavorite: Bool = false 

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
