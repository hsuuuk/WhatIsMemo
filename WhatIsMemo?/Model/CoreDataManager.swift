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
    
    // MARK: - [Read] 저장된 데이터 읽어오기
    
    var memoList = [CoreData]()
    var fixedMemoList = [CoreData]()
    var filteredMemoList = [CoreData]()
    
    func fetchMemoList() {
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        let sortByDate = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDate]
        
        guard let context = context else { return }
        do {
            guard let fetchedDataList = try context.fetch(request) as? [CoreData] else { return }
            memoList = fetchedDataList.filter { $0.isFixed == false }
            fixedMemoList = fetchedDataList.filter { $0.isFixed == true }
        } catch {
            print("Fetch Error")
        }
    }
    
    // MARK: - [Create] 데이터 생성하기
    
    func createMemo(Text: String?, completion: @escaping () -> Void) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else { return }
        guard let CoreData = NSManagedObject(entity: entity, insertInto: context) as? CoreData else { return }
        CoreData.text = Text
        CoreData.date = Date()
        CoreData.isFixed = false
        
        do {
            try context.save()
            completion()
        } catch {
            print("Create Error")
        }
    }
    
    // MARK: - [Delete] 데이터 삭제하기
    
    func deleteMemo(data: CoreData, completion: @escaping () -> Void) {
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        guard let date = data.date else { return }
        request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        
        guard let context = context else { return }
        do {
            guard let fetchedDataList = try context.fetch(request) as? [CoreData] else { return }
            guard let target = fetchedDataList.first else { return }
            context.delete(target)
            do {
                try context.save()
                completion()
            } catch {
                print("Save Error of Delete")
            }
        } catch {
            print("Delete Error")
        }
    }
    
    // MARK: - [Update] 데이터 수정하기
    
    func updateMemo(newData: CoreData, completion: @escaping () -> Void) {
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        guard let date = newData.date else { return }
        request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        
        guard let context = context else { return }
        do {
            guard let fetchedDataList = try context.fetch(request) as? [CoreData] else { return }
            guard var target = fetchedDataList.first else { return }
            target = newData
            do {
                try context.save()
                completion()
            } catch {
                print("Save Error of Update")
            }
        } catch {
            print("Update Error")
        }
    }
}


