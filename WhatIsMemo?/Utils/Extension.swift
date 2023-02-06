//
//  Extension.swift
//  WhatIsMemo?
//
//  Created by 심현석 on 2023/01/29.
//

import UIKit

extension Date {
    static func dateFormatter(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd(E)"
        return dateFormatter.string(from: date)
    }
}


