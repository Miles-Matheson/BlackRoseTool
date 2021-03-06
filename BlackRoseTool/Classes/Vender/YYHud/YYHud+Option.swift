//
//  YYHud+Option.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

public extension YYHud {
    ///
    typealias OptionInfo = [Option]
    
    enum Option {
        case dim						///黑色蒙层
        case modal						///模态显示，禁止交互
        case duration(second: Double)	///持续时间
        
        public static func ==(lhs: Option, rhs: Option) -> Bool {
            switch (lhs, rhs) {
            case (.dim, .dim): return true
            case (.modal, .modal): return true
            case (.duration(_), .duration(_)): return true
            default: return false
            }
        }
    }
}

extension Collection where Element == YYHud.Option {
    var isDim: Bool {
        return contains{ $0 == .dim }
    }
    
    var isModal: Bool {
        return contains{ $0 == .modal }
    }
    
    var duration: Double? {
        if let item = lastMatchValue(.duration(second: 0)),
            case .duration(let duration) = item {
            return duration
        }
        return nil
    }
    
    func lastMatchValue(_ target: Element) -> Element? {
        return reversed().first { $0 == target }
    }
}




