//
//  MovieDetailViewController.swift
//  MovieLister
//
//  Created by Mustafa on 18.12.2024.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    //MARK: - UI Elements
    private var starButton = UIButton()
    private let posterImage = UIImageView()
    private let descriptionLabel = UILabel()
    private let voteCountLabel = UILabel()
    private let titleLabel = UILabel()
    private let spinnerView = SpinnerView()

    private var viewModel: MovieDetailViewModel!
    
    var movieId: Int? {
        didSet {
            if let movieId = movieId {
                self.viewModel = MovieDetailViewModel(movieId: movieId)
            }
        }
    }
    
    //MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "second_title".localized
        
        view.backgroundColor = .white
        setupStarButton()
        setupViews()
        setupBindings()
        updateStarButton()
        
        if movieId != nil {
            spinnerView.show(on: view)
            viewModel.fetchMovieDetail()
        }
    }

    private func setupViews() {
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(voteCountLabel)
        
        posterImage.contentMode = .scaleToFill
        posterImage.clipsToBounds = true
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 10
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        voteCountLabel.textAlignment = .right
        voteCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            posterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            posterImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: voteCountLabel.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            voteCountLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 16),
            voteCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupStarButton() {
        starButton = UIButton(type: .system)
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .systemBlue
        starButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        let customBarButtonItem = UIBarButtonItem(customView: starButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
    }

    private func setupBindings() {
        viewModel.onMovieFetched = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinnerView.hide()
                self.updateUI()
            }
        }
        
        viewModel.onFavoriteUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinnerView.hide()
                self.updateStarButton()
                self.showAlert("remove_favorite".localized, title: "success_title".localized)
            }
        }

        viewModel.onImageUpload = { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinnerView.hide()
                self.updateStarButton()
                self.showAlert("image_success".localized, title: response)
            }
        }

        viewModel.onError = { [weak self] error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinnerView.hide()
                self.showAlert("\(error.localizedDescription)")
            }
        }
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let aspectWidth = targetSize.width / image.size.width
        let aspectHeight = targetSize.height / image.size.height
        let scaleFactor = min(aspectWidth, aspectHeight)
        let newSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    
    private func convertImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        return imageData.base64EncodedString()
    }

    private func updateStarButton() {
        let isFavorite = CoreDataManager.shared.isFavorite(movieId: viewModel.movie.id)
        starButton.setImage(UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
    }
    
    private func updateUI() {
        titleLabel.text = viewModel.movie.title
        descriptionLabel.text = viewModel.movie.overview
        voteCountLabel.text = "Vote Count: \(viewModel.movie.voteCount)"
        if let imageUrl = URL(string: viewModel.movie.posterURL) {
            posterImage.loadImage(from: imageUrl, placeholder: UIImage(named: "placeholder"))
        }
        updateStarButton()
    }
    // MARK: - objc functions
    @objc private func toggleFavorite() {
        self.spinnerView.show(on: self.view)
        guard let image = posterImage.image else {
            return
        }
        guard let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 600, height: 600)) else { return }
        guard let base64String = convertImageToBase64(image: resizedImage) else { return }
        viewModel?.toggleFavorite(base64String: base64String)
    }
}

