//
//  MovieDetailViewModel.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation

final class MovieDetailViewModel {
    var movie: MovieModel
    private let movieId: Int

    var onFavoriteUpdated: (() -> Void)?
    var onImageUpload: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onMovieFetched: (() -> Void)?

    init(movieId: Int) {
        self.movieId = movieId
        self.movie = MovieModel(id: 0, title: "", posterPath: "", overview: "",voteAverage: 0, voteCount: 0, isFavorite: false) 
    }
    
    func fetchMovieDetail() {
        TMDBService.shared.fetchMovieDetail(movieId: movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                self.movie = movie
                self.onMovieFetched?()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }

    func toggleFavorite(base64String: String) {
        if CoreDataManager.shared.isFavorite(movieId: movie.id) {
            CoreDataManager.shared.removeFavorite(movieId: movie.id)
            movie.isFavorite = true
        } else {
            CoreDataManager.shared.saveFavorite(movie: movie)
            uploadMovieImage(base64String: base64String)
            movie.isFavorite = false
        }
        onFavoriteUpdated?()
    }

    private func uploadMovieImage(base64String: String) {
        ImageUploadService.shared.uploadImage(base64String: base64String, prompt: "upload_prompt".localized) { result in
            switch result {
            case .success(let response):
                // Loading indicator test.
//                Thread.sleep(forTimeInterval: 3)
                self.onImageUpload?()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
}
