//
//  UpcomingMovieTableViewCell.swift
//  NetflixClone
//
//  Created by Maks Kokos on 31.10.2022.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {

    static let cellId = "UpcomingMovieTableViewCell"
    
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playMovieButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.alpha = 0.8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(playMovieButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let moviePosterUIImageViewConstraints = [
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let movieTitleLabelConstraints = [
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 20),
            movieTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playMovieButtonConstraints = [
            playMovieButton.centerYAnchor.constraint(equalTo: moviePosterImageView.centerYAnchor),
            playMovieButton.centerXAnchor.constraint(equalTo: moviePosterImageView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(moviePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
        NSLayoutConstraint.activate(playMovieButtonConstraints)
    }
    
    public func configure(with movie: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterURL)") else { return }
        moviePosterImageView.sd_setImage(with: url, completed: nil)
        movieTitleLabel.text = movie.movieName
    }
    
}
