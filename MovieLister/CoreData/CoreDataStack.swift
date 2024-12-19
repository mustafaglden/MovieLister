//
//  CoreDataStack.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieLister") 
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveFavorite(movie: MovieModel) {
        let context = CoreDataManager.shared.context
        let favoriteMovie = CoreDataMovie(context: context)
        favoriteMovie.id = Int64(movie.id)
        favoriteMovie.title = movie.title
        favoriteMovie.posterPath = movie.posterPath
        favoriteMovie.overview = movie.overview
        favoriteMovie.voteCount = Int64(movie.voteCount)
        
        CoreDataManager.shared.saveContext()
    }
    
    func removeFavorite(movieId: Int) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        if let result = try? context.fetch(fetchRequest).first {
            context.delete(result)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        return (try? context.count(for: fetchRequest)) ?? 0 > 0
    }
    
    func fetchFavorites() -> [CoreDataMovie] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
        
        return (try? context.fetch(fetchRequest)) ?? []
    }


}
