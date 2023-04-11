//
//  SelectController.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/27.
//

import UIKit
import SnapKit

private let identifier = "cell"

class MainController: UIViewController {
    
    var tableView = UITableView()
    
    var searchController = UISearchController()
    var isFiltering: Bool {
        let isActive = searchController.isActive
        let isEmpty = searchController.searchBar.text?.isEmpty == false
        return isActive && isEmpty
    }
    
    var dataManager = CoreDataManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.title = "메모"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        dataManager.fetchMemoList()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: identifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func rightBarButtonTapped() {
        let controller = PlusController()
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.navigationBar.tintColor = .black
    }
}

extension MainController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? dataManager.filteredMemoList.count : (section == 0 ? dataManager.fixedMemoList.count : dataManager.memoList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        if isFiltering {
            cell.memoData = dataManager.filteredMemoList[indexPath.row]
        } else {
            if indexPath.section == 0 {
                cell.memoData = dataManager.fixedMemoList[indexPath.row]
            } else {
                cell.memoData = dataManager.memoList[indexPath.row]
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            // 원하는 액션 추가
            if indexPath.section == 0 {
                let deletedMemo = self.dataManager.fixedMemoList[indexPath.row]
                self.dataManager.deleteMemo(data: deletedMemo) {
                    self.dataManager.fetchMemoList()
                    self.tableView.reloadData()
                }
                success(true)
            } else {
                let deletedMemo = self.dataManager.memoList[indexPath.row]
                self.dataManager.deleteMemo(data: deletedMemo) {
                    self.dataManager.fetchMemoList()
                    self.tableView.reloadData()
                }
                success(true)
            }
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let unfix = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
                // 원하는 액션 추가
                let fixedMemo = self.dataManager.fixedMemoList[indexPath.row]
                fixedMemo.isFixed = false
                self.dataManager.updateMemo(newData: fixedMemo) {
                    self.dataManager.fetchMemoList()
                    self.tableView.reloadData()
                }
                success(true)
            }
            unfix.backgroundColor = .systemBlue
            unfix.image = UIImage(systemName: "pin.slash.fill")
            return UISwipeActionsConfiguration(actions: [unfix])
        } else {
            let fix = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
                // 원하는 액션 추가
                let fixedMemo = self.dataManager.memoList[indexPath.row]
                fixedMemo.isFixed = true
                self.dataManager.updateMemo(newData: fixedMemo) {
                    self.dataManager.fetchMemoList()
                    self.tableView.reloadData()
                }
                success(true)
            }
            fix.backgroundColor = .systemBlue
            fix.image = UIImage(systemName: "pin.fill")
            return UISwipeActionsConfiguration(actions: [fix])
        }
    }
}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SelectedController()
        if indexPath.section == 0 {
            controller.selectedData = dataManager.fixedMemoList[indexPath.row]
            navigationController?.present(controller, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            controller.selectedData = dataManager.memoList[indexPath.row]
            navigationController?.present(controller, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        
        if isFiltering {
            return nil
        } else {
            if section == 0 {
                header?.textLabel?.text = "고정된 메모"
            } else {
                header?.textLabel?.text = "메모"
            }
            header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            header?.textLabel?.textColor = UIColor.black
            return header
        }
    }
}

extension MainController: CellDelegate {
    func cell(_ cell: Cell, data: CoreData) {
        let controller = EditController()
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        if indexPath.section == 0 {
            controller.editData = dataManager.fixedMemoList[indexPath.row]
        } else {
            controller.editData = dataManager.memoList[indexPath.row]
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        var filter = dataManager.fixedMemoList.filter { $0.text?.lowercased().contains(text.lowercased()) ?? false }
        filter.append(contentsOf: dataManager.memoList.filter { $0.text?.lowercased().contains(text.lowercased()) ?? false })
        dataManager.filteredMemoList = filter
        tableView.reloadData()
    }
}
