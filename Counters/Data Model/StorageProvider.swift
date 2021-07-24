//
//  StorageProvider.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 24/07/21.
//

import CoreData

class StorageProvider {
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "Counters")

        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
    }
}

extension StorageProvider {
    func getCounters() -> [Counter] {
        let fetchRequest: NSFetchRequest<Counter> = Counter.fetchRequest()

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    func saveCounter(named name: String) {
        let counter = Counter(context: persistentContainer.viewContext)
        counter.title = name

        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }

    func deleteCounter(_ counters: [Counter]) {

        for counter in counters {
            persistentContainer.viewContext.delete(counter)
        }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }

    func updateCounter(_ counter: Counter) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}
