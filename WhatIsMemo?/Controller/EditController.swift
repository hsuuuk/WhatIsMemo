//
//  EditController.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/27.
//

import UIKit
import SnapKit

class EditController: UIViewController {
    
    let dataManager = CoreDataManager.shared
    
    var editData: CoreData? {
        didSet { configure() }
    }
    
    private let editMemoTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func configure() {
        guard let text = editData?.text else { return }
        editMemoTextView.text = text
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        
        let rightBarButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(editMemoTextView)
        editMemoTextView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    @objc func rightBarButtonTapped() {
        if let editedData = editData {
            if let text = editMemoTextView.text, text != editData?.text {
                editedData.text = text
                editedData.date = Date()
                dataManager.updateMemo(newData: editedData) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
