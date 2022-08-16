//
//  CoreDataManager.swift
//  Cocktails App
//
//  Created by Konstantin Korchak on 12.08.2022.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
// MARK: - Core Data stack
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
// MARK: - Core Data Methods
    
    func create(_ id: String) {
        if let id = Int16(id) {
            let favorite = Favorite(context: viewContext)
            favorite.id = id
            favorite.date = Date.now
            saveContext()
        }
    }
    
    func checkValue(_ id: String) -> Bool {
        var like = false
        fetchValue(id) { favorites in
            if favorites.count > 0 {
                like = true
            }
        }
        return like
    }
    
    func deleteValue(_ id: String) {
        fetchValue(id) { favorites in
            for favorite in favorites {
                viewContext.delete(favorite)
            }
            saveContext()
        }
    }
    
// MARK: - Core Data SaveContext
    
    private func fetchValue(_ id: String, completion: ([Favorite]) -> Void) {
        guard let id = Int16(id) else { return }
        let request = Favorite.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", id)
        request.predicate = predicate
        do {
            let ids = try viewContext.fetch(request)
            completion(ids)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
