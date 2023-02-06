//
//  SelectCell.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/27.
//

import UIKit
import SnapKit

protocol CellDelegate: AnyObject {
    func cell(_ cell: Cell, data: CoreData)
}

class Cell: UITableViewCell {
    
    var memoData: CoreData? {
        didSet { configure() }
    }

    weak var delegate: CellDelegate?
    
    var outlineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .systemFill
        return view
    }()
    
    var memoLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.numberOfLines = 3
        return lb
    }()
    
    var inlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    var dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    private lazy var editButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("수정", for: .normal)
        bt.backgroundColor = .white
        bt.layer.cornerRadius = 3
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.layer.borderWidth = 0.5
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.setTitleColor(.black, for: .normal)
        bt.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editButtonTapped() {
        guard let memoData = memoData else { return }
        delegate?.cell(self, data: memoData)
    }
    
    func configure() {
        guard let text = memoData?.text else { return }
        memoLabel.text = text

        guard let date = memoData?.date else { return }
        dateLabel.text = Date.dateFormatter(date)
    }
    
    func setupUI() {
        contentView.addSubview(outlineView)
        outlineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        outlineView.addSubview(inlineView)
        inlineView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.left.right.equalToSuperview()
        }
        
        outlineView.addSubview(memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(inlineView.snp.top).offset(-5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        inlineView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        inlineView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(40)
        }
    }
}
