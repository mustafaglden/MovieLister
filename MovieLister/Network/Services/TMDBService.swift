//
//  TMDBService.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//


import Foundation

final class TMDBService {
    static let shared = TMDBService()

    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponseModel, Error>) -> Void) {
        let endpoint = APIEndpoint.popularMovies(page: page)
        print("FetchMovies-TMDBService")
        NetworkManager.shared.request(endpoint: endpoint, completion: completion)
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        let endpoint = APIEndpoint.movieDetail(movieId: movieId)
        NetworkManager.shared.request(endpoint: endpoint, completion: completion)
    }
}
