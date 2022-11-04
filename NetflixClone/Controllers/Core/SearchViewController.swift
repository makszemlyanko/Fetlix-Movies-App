//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Maks Kokos on 29.10.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies: [Movie] = [Movie]()

    private let discoverTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(UpcomingMovieTableViewCell.self, forCellReuseIdentifier: UpcomingMovieTableViewCell.cellId)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search movies or tv shows"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .systemRed
        
        getDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func getDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.cellId, for: indexPath) as? UpcomingMovieTableViewCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(movieName: (movie.name ?? movie.title) ?? "Unknown name", posterURL: movie.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else { return }
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    resultsController.movies = movies
                    resultsController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
