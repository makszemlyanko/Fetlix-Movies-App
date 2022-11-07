//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Maks Kokos on 29.10.2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let cellId = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = [Movie]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.cellId)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .systemBackground
        
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movie: [Movie]) {
        self.movies = movie
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadMovieAt(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadMovieWith(movie: movies[indexPath.item]) { result in
            switch result {
            case .success():
                print("Downloaded to database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.cellId, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        cell.configurePoster(path: movies[indexPath.row].poster_path ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movies.count
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.item]
        guard let movieName = movie.name ?? movie.title else { return }
        APICaller.shared.getMoviesFromYouTube(with: movieName + " trailer") { [weak self] result in
            switch result {
            case .success(let video):
                let movie = self?.movies[indexPath.item]
                guard let movieOverview = movie?.overview else { return }
                guard let strongSelf = self else { return }
                let viewModel = MoviePreviewViewModel(movie: movieName, youtubeVideo: video, movieOverview: movieOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download",
                                          image: UIImage(systemName: "arrow.down.to.line"),
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          attributes: .destructive,
                                          state: .off) { _ in
                self?.downloadMovieAt(indexPath: indexPath)
            }
                                                    
                                                    return UIMenu(title: "",
                                                                  image: nil,
                                                                  identifier: nil,
                                                                  options: .displayInline,
                                                                  children: [downloadAction])
        }
        return config
    }
}
