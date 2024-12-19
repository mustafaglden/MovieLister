//
//  MovieListViewModel.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import Foundation

final class MovieListViewModel {
    private var currentPage = 1
    private var totalPages = 1
    private var allMovies: [MovieModel] = []
    private var filteredMovies: [MovieModel] = []
    var favorites: [Int] = [] // Stores favorite movie IDs

    var movies: [MovieModel] {
        filteredMovies.isEmpty ? allMovies : filteredMovies
    }

    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchMovies() {
        guard currentPage <= totalPages else { return }
        print("FetchMovies viewModel")
        TMDBService.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.totalPages = response.page
                self?.allMovies.append(contentsOf: response.results)
                self?.onMoviesUpdated?()
                self?.currentPage += 1
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }

    func searchMovies(query: String) {
        filteredMovies = allMovies.filter {
            $0.title.lowercased().contains(query.lowercased())
        }
        onMoviesUpdated?()
    }

    func toggleFavorite(movie: MovieModel) {
        if let index = favorites.firstIndex(of: movie.id) {
            favorites.remove(at: index)
            CoreDataManager.shared.removeFavorite(movieId: movie.id)
        } else {
            favorites.append(movie.id)
            CoreDataManager.shared.saveFavorite(movie: movie)
        }
        onMoviesUpdated?()
    }

    func isFavorite(movieId: Int) -> Bool {
        return favorites.contains(movieId)
    }
}
