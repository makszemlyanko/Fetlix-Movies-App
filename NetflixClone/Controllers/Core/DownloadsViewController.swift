//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Maks Kokos on 29.10.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var movies: [MovieItem] = [MovieItem]()
    
    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellId)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemRed
        
        view.addSubview(downloadedTable)
        
        downloadedTable.dataSource = self
        downloadedTable.delegate = self
        
        getDownloadedMovies()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.getDownloadedMovies()
    }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
    
    private func getDownloadedMovies() {
        DataPersistenceManager.shared.getMoviesFromDataBase { [weak self]  result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    


}

extension DownloadsViewController: UITableViewDataSource {
    
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

extension DownloadsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.removeMovieWith(movie: movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    self?.movies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    print("Movie removed from DataBase")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
    
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


