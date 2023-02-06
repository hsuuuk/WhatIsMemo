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
            
    var memoDataArr: [Data] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "메모"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func rightBarButtonTapped() {
        let controller = PlusController()
        controller.plusCompletionButtonAction = { data in
            self.memoDataArr.insert(data, at: 0)
        }
        
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.navigationBar.tintColor = .black
    }
}

extension MainController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        cell.memoData = memoDataArr[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            // 원하는 액션 추가
            self.memoDataArr.remove(at: indexPath.row)
            success(true)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")

            return UISwipeActionsConfiguration(actions: [delete])
        }
}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SelectedController()
        controller.selectedData = memoDataArr[indexPath.row]
        navigationController?.present(controller, animated: true)
    }
}

extension MainController: CellDelegate {
    func cell(_ cell: Cell, data: Data) {
        let controller = EditController()
        controller.editData = data

        controller.editCompletionButtonAction = { data in
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            self.memoDataArr.remove(at: indexPath.row)
            self.memoDataArr.insert(data, at: 0)
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}



