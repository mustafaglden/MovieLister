//
//  MovieListViewModel.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation

final class MovieListViewModel {
    private var allMovies: [MovieModel] = []
    private var filteredMovies: [MovieModel] = []
    
    var currentPage = 1
    var totalPages = 1

    var movies: [MovieModel] {
        filteredMovies.isEmpty ? allMovies : filteredMovies
    }

    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchMovies() {
        guard currentPage <= totalPages else { return }
        TMDBService.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.totalPages = response.totalPages
                self.allMovies.append(contentsOf: response.results)
                self.onMoviesUpdated?()
                self.currentPage += 1
            case .failure(let error):
                self.onError?(error)
            }
        }
    }

    func searchMovies(query: String) {
        filteredMovies = allMovies.filter {
            $0.title.lowercased().contains(query.lowercased())
        }
        onMoviesUpdated?()
    }
}
