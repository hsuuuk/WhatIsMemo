//
//  TextViewPlaceholder.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/30.
//

import UIKit
import SnapKit

class InputTextView : UITextView {
    
    // MARK: - Properties
    
    var placeholderText : String? {
        didSet { placeholderLabel.text = placeholderText}
    }
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
