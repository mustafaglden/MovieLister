//
//  MovieDetailViewModel.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation

final class MovieDetailViewModel {
    var movie: MovieModel
    var onFavoriteUpdated: (() -> Void)?
    var onImageUpload: (() -> Void)?
    var onError: ((Error) -> Void)?

    init(movie: MovieModel) {
        self.movie = movie
    }

    func toggleFavorite(base64String: String) {
        if CoreDataManager.shared.isFavorite(movieId: movie.id) {
            CoreDataManager.shared.removeFavorite(movieId: movie.id)
        } else {
            CoreDataManager.shared.saveFavorite(movie: movie)
            uploadMovieImage(base64String: base64String)
        }
        onFavoriteUpdated?()
    }

    private func uploadMovieImage(base64String: String) {
        ImageUploadService.shared.uploadImage(base64String: base64String, prompt: "Movie Image Upload") { result in
            switch result {
            case .success(let response):
                print("Upload successful: \(response)")
                self.onImageUpload?()
            case .failure(let error):
                print("Upload failed: \(error.localizedDescription)")
                self.onError?(error)
            }
        }
    }
}
