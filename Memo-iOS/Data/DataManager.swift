//
//  DataManager.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    
    private init() {
        
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    // 저장된 메모 불러오기
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    // 새로운 메모 추가하기
    func addNewMemo(_ memo: String?) {
        
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        memoList.insert(newMemo, at: 0)
        
        saveContext()
    }
    

    func deleteMemo(_ memo: Memo?) {
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    // Save image
    func saveImage(data: Data) {
        let memo = Memo(context: mainContext)
        memo.image = data
        
        do {
            try saveContext()
            print("Image Saved")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Memo_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
