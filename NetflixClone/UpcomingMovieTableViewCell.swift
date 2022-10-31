//
//  UpcomingMovieTableViewCell.swift
//  NetflixClone
//
//  Created by Maks Kokos on 31.10.2022.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {

    static let cellId = "UpcomingMovieTableViewCell"
    
    private let moviePosterUIImageView: UIImageView = {
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(moviePosterUIImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(playMovieButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let moviePosterUIImageViewConstraints = [
            moviePosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            moviePosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let movieTitleLabelConstraints = [
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterUIImageView.trailingAnchor, constant: 20),
            movieTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(moviePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
    }
    
    public func configure(with movie: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterURL)") else { return }
        moviePosterUIImageView.sd_setImage(with: url, completed: nil)
        movieTitleLabel.text = movie.movieName
    }
    
}
