//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Maks Kokos on 29.10.2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var movies: [Movie] = [Movie]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellId)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemRed
        
        view.addSubview(upcomingTable)
        
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        
        getUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    private func getUpcomingMovies() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }


}

extension UpcomingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellId, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(movieName: (movie.name ?? movie.title) ?? "Unknown name", posterURL: movie.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension UpcomingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let movieName = movie.name ?? movie.title else { return }
        
        APICaller.shared.getMoviesFromYouTube(with: movieName) { [weak self] result  in
            switch result {
            case .success(let video):
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    vc.configure(with: MoviePreviewViewModel(movie: movieName, youtubeVideo: video, movieOverview: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
