//
//  CGFloat+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif

public extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat.random(in: 0.0..<1.0)
    }
}

// MARK: - Properties
public extension CGFloat {
    var center: CGFloat {
        return (self / 2)
    }
    
    var abs: CGFloat {
        return Swift.abs(self)
    }
    
    ///向上取整 ceil(2)=ceil(1.2)=cei(1.5)=2.0
    var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    ///向下取整 y=9.99999，floor(y)=9.0
    var floor: CGFloat {
        return Foundation.floor(self)
    }
    
    ///四舍五入
    var round: CGFloat {
        return Foundation.round(self)
    }
    
    /// 角度的弧度值。Radian value of degree input.
    /// 90.degreesToRadians == π/2
    var degreesToRadians: CGFloat {
        return CGFloat.pi * self / 180.0
    }
    
    /// SwifterSwift: Degree value of radian input.
    /// π/2.radiansToDegrees == 90
    var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    var isPositive: Bool {
        return self > 0
    }
    
    var isNegative: Bool {
        return self < 0
    }
}

// MARK: -
public extension CGFloat {
    ///
    func toString(format: String? = nil) -> String {
        return format != nil ? String(format: "%\(format!)f", self) : String(self.toFloat())
    }
    
    /// SwifterSwift: Float.
    func toFloat() -> Float {
        return Float(self)
    }
    
    /// SwifterSwift: Double.
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func toUInt() -> UInt {
        return UInt(self)
    }
}
#endif

