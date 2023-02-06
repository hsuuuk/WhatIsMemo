//
//  CoreDataManager.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/02/06.
//

import UIKit
import CoreData

private let name = "CoreData"

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    
    func fetchMemoListFromCoreData() -> [CoreData] {
        var dataList: [CoreData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: name)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedDataList = try context.fetch(request) as? [CoreData] {
                    dataList = fetchedDataList
                }
            } catch {
                print("Fetch Error")
            }
        }
        return dataList
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    
    func createMemo(Text: String?, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: name, in: context) {
                if let CoreData = NSManagedObject(entity: entity, insertInto: context) as? CoreData {
                    CoreData.text = Text
                    CoreData.date = Date()
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print("Create Error")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기
    
    func deleteMemo(data: CoreData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: name)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedDataList = try context.fetch(request) as? [CoreData] {
                    if let targetMemo = fetchedDataList.first {
                        context.delete(targetMemo)
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print("Delete Error")
                                completion()
                            }
                        }
                    }
                }
            } catch {
                print("Delete Error")
                completion()
            }
        }
    }
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기
    
    func updateMemo(newMemoData: CoreData, completion: @escaping () -> Void) {
        guard let date = newMemoData.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: name)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedDataList = try context.fetch(request) as? [CoreData] {
                    if var targetMemo = fetchedDataList.first {
                        targetMemo = newMemoData
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print("Update Error")
                                completion()
                            }
                        }
                    }
                }
            } catch {
                print("Update Error")
                completion()
            }
        }
    }
}


