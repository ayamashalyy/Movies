//
//  Database Manager.swift
//  Movies
//
//  Created by aya on 05/10/2024.
//

import Foundation
import CoreData
import UIKit


class DatabaseManager {
    
    
    enum DatabaseError: Error
    {
        case failedToSaveDate
        case failedToFetchDate
        case failedTodeleteData
    }
    
    static let shared = DatabaseManager()
       
    func downloadTitleWith(model: Title, completion: @escaping ((Result<Void, Error>) -> Void)) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let titleItem = TitleItem(context: context)
        
        titleItem.id = Int64(model.id ?? 0)
        titleItem.media_type = model.media_type
        titleItem.original_name = model.original_name
        titleItem.original_title = model.original_title
        titleItem.poster_path = model.poster_path
        titleItem.overview = model.overview
        titleItem.vote_count = Int64(model.vote_count ?? 0)
        titleItem.release_date = model.release_date
        titleItem.vote_average = model.vote_average ?? 0.0
        
        do
        {
         try? context.save()
         completion(.success(()))
        }catch {
            completion(.failure(DatabaseError.failedToSaveDate))
        }
    }
    
    
    func fetchTitlesFromDatabase(completion: @escaping ((Result<[TitleItem], Error>) -> Void)){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
          let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DatabaseError.failedToFetchDate))
        }
    }
    
    func deleteFromDatabase(model: TitleItem, completion: @escaping ((Result<Void, Error>) -> Void)){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
           try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedTodeleteData))
        }
        
    }
    
    

}
