//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Maks Kokos on 07.11.2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToGetData
        case failedToRemoveData
    }
     
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.id = Int64(movie.id)
        item.media_type = movie.media_type
        item.name = movie.name
        item.title = movie.title
        item.original_name = movie.original_name
        item.original_title = movie.original_title
        item.overview = movie.overview
        item.poster_path = movie.poster_path
        item.release_date = movie.release_date
        item.vote_count = Int64(movie.vote_count)
        item.vote_average = movie.vote_average
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData ))
        }
    }
    
    func getMoviesFromDataBase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DataBaseError.failedToGetData))
        }
    }
    
    func removeMovieWith(movie: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(movie)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToRemoveData))
        } 
    }
     
}
