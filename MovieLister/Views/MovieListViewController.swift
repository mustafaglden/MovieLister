//
//  MovieListViewController.swift
//  MovieLister
//
//  Created by Mustafa on 16.12.2024.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private var searchBar = UISearchBar()
    private let searchBarContainer = UIView()
    
    private var viewModel = MovieListViewModel()
    
    private var isSingleLayout: Bool = true
        
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "first_title".localized
        
        setupSwitchViewButton()
        setupSearchBar()
        setupCollectionView()
        setupBindings()
        viewModel.fetchMovies()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupSwitchViewButton() {
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
        customButton.backgroundColor = .lightGray
        customButton.tintColor = .white
        customButton.layer.cornerRadius = 8
        customButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        customButton.addTarget(self, action: #selector(changeViewTapped), for: .touchUpInside)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "search_placeholder".localized
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.backgroundColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.addSubview(searchBar)
        
        view.addSubview(searchBarContainer)
        
        NSLayoutConstraint.activate([
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieListCollectionCell.self, forCellWithReuseIdentifier: "MovieListCollectionCell")
        collectionView.register(CollectionViewButton.self, forCellWithReuseIdentifier: "CollectionViewButton")
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupBindings() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }

    private func updateCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
    //MARK: objc functions
    @objc func changeViewTapped() {
        isSingleLayout.toggle()
        let buttonImage = UIImage(systemName: isSingleLayout ? "rectangle.grid.1x2.fill" : "square.grid.2x2.fill")
        if let customButton = navigationItem.rightBarButtonItem?.customView as? UIButton {
            customButton.setImage(buttonImage, for: .normal)
        }
        updateCollectionViewLayout()
    }
    
    @objc func loadMoreTapped() {
        viewModel.fetchMovies()
    }
}

// MARK: - Extensions
extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < viewModel.movies.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as? MovieListCollectionCell else {
                return UICollectionViewCell()
            }
            if let imageUrl = URL(string: viewModel.movies[indexPath.row].posterURL) {
                if CoreDataManager.shared.isFavorite(movieId: viewModel.movies[indexPath.row].id) {
                    cell.configure(with: imageUrl, title: viewModel.movies[indexPath.row].title, showStar: true)
                } else {
                    cell.configure(with: imageUrl, title: viewModel.movies[indexPath.row].title, showStar: false)
                }
            }
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewButton", for: indexPath) as! CollectionViewButton
            cell.button.setTitle("load_button_title".localized, for: .normal)
            cell.button.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < viewModel.movies.count {
            let width = isSingleLayout ? collectionView.frame.width - 16 : (collectionView.frame.width / 2) - 12
            return CGSize(width: width, height: isSingleLayout ? 300 : 200)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < viewModel.movies.count {
            let detailVC = MovieDetailViewController()
            detailVC.movieId = viewModel.movies[indexPath.row].id
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(query: searchText)
    }
}
