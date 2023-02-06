//
//  PlusController.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/29.
//

import UIKit
import SnapKit

class PlusController: UIViewController {
    
    var plusCompletionButtonAction: ((Data) -> Void)?
    
    private let plusMemoTextView: InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.placeholderText = "내용을 입력하세요."
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        
        let rightBarButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(plusMemoTextView)
        plusMemoTextView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    @objc func rightBarButtonTapped() {
        if plusMemoTextView.text != "" {
            guard let text = plusMemoTextView.text else { return }
            let plusData = Data(text: text, date: Date.dateFormatter())
            plusCompletionButtonAction?(plusData)

            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
