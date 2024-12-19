//
//  MovieListViewController.swift
//  MovieLister
//
//  Created by Mustafa on 16.12.2024.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let tableReuseIdentifier = "MovieListTableCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let collectionReuseIdentifier = "MovieListCollectionCell"
    
    private var isTableView: Bool = true
    private var searchBar = UISearchBar()
    private let searchBarContainer = UIView()
    
    private var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Contents"

        tableView.alpha = 0
        collectionView.alpha = 1
        
        setupSwitchViewButton()
        setupSearchBar()
        setupTableView()
        setupCollectionView()
        setupBindings()
        viewModel.fetchMovies()
        // Do any additional setup after loading the view.
    }
    
    private func setupSwitchViewButton() {
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: isTableView ? "line.3.horizontal" : "square.grid.2x2.fill"), for: .normal)
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
        searchBar.placeholder = "Search movies..."
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

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieListTableCell.self, forCellReuseIdentifier: tableReuseIdentifier)
        
        view.addSubview(tableView)
                
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieListCollectionCell.self, forCellWithReuseIdentifier: collectionReuseIdentifier)
        collectionView.backgroundColor = .white
        
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
                self?.tableView.reloadData()
                self?.collectionView.reloadData()
            }
        }

        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }
    
    @objc func changeViewTapped() {
        isTableView.toggle()
        if isTableView {
            tableView.alpha = 0
            collectionView.alpha = 1
        } else {
            tableView.alpha = 1
            collectionView.alpha = 0
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIdentifier, for: indexPath) as? MovieListTableCell else {
            return UITableViewCell()
        }
        if let imageUrl = URL(string: viewModel.movies[indexPath.row].posterURL) {
            cell.configure(with: imageUrl, title: viewModel.movies[indexPath.row].title)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController()
        detailVC.movie = viewModel.movies[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as? MovieListCollectionCell else {
            return UICollectionViewCell()
        }
        if let imageUrl = URL(string: viewModel.movies[indexPath.row].posterURL) {
            cell.configure(with: imageUrl, title: viewModel.movies[indexPath.row].title)
        }
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController()
        detailVC.movie = viewModel.movies[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(query: searchText)
    }
}
