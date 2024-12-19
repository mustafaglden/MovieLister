//
//  MovieDetailViewController.swift
//  MovieLister
//
//  Created by Mustafa on 18.12.2024.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    private var starButton = UIButton()
    private let posterImage = UIImageView()
    private let descriptionLabel = UILabel()
    private let voteCountLabel = UILabel()
    private let titleLabel = UILabel()
    private let spinnerView = SpinnerView()

    private var viewModel: MovieDetailViewModel!
    
    public var movie: MovieModel? {
        didSet {
            if let movie = movie {
                self.viewModel = MovieDetailViewModel(movie: movie)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupStarButton()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        guard let imageUrl = URL(string: viewModel.movie.posterURL) else {
            return
        }
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(voteCountLabel)
        
        posterImage.loadImage(from: imageUrl, placeholder: UIImage(named: "placeholder"))
        posterImage.contentMode = .scaleToFill
        posterImage.clipsToBounds = true
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = viewModel.movie.title
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = viewModel.movie.overview
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 10
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        voteCountLabel.text = "\(viewModel.movie.voteCount)"
        voteCountLabel.textAlignment = .right
        voteCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        viewModel.onFavoriteUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateStarButton()
            }
        }

        viewModel.onImageUpload = { [weak self] in
            DispatchQueue.main.async {
                self?.spinnerView.hide()
                self?.showAlert("Image uploaded successfully.", title: "Success!!")
            }
            print("Image uploaded successfully!")
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.spinnerView.hide()
                self?.showAlert("\(error.localizedDescription)", title: "Error!")
            }
            print("Error: \(error)")
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

    @objc private func toggleFavorite() {
        self.spinnerView.show(on: self.view)
        guard let image = posterImage.image else {
            return
        }
        guard let base64String = convertImageToBase64(image: image) else { return }
        viewModel?.toggleFavorite(base64String: base64String)
    }
}

