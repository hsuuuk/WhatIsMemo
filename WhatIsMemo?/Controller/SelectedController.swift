//
//  PlusController.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/29.
//

import UIKit
import SnapKit

class SelectedController: UIViewController {
    
    var fetchText: ((String) -> Void)?
    
    var selectedData: Data? {
        didSet { configure() }
    }
    
    private let textLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.numberOfLines = 0
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func configure() {
        textLabel.text = selectedData?.text
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
                
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    @objc func rightBarButtonTapped() {
        let controller = EditController()
        controller.editData = selectedData
        navigationController?.pushViewController(controller, animated: true)
    }
}
