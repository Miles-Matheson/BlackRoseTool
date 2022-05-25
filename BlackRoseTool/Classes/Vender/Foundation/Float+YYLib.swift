//
//  Float+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import Foundation
import CoreGraphics

// MARK: - Float
public extension Float {
	func toString(format: String? = nil) -> String {
		return format != nil ? String(format: "%\(format!)f", self) : String(self)
	}
	
	func toInt() -> Int {
		return Int(self)
	}
	
	func toUInt() -> UInt {
		return UInt(self)
	}
	
	func toDouble() -> Double {
		return Double(self)
	}
	
	func toCGFloat() -> CGFloat {
		return CGFloat(self)
	}
}

// MARK: - Double
public extension Double {
	func toString(format: String? = nil) -> String {
		return format != nil ? String(format: "%\(format!)f", self) : String(self)
	}
	
	func toInt() -> Int {
		return Int(self)
	}
	
	func toUInt() -> UInt {
		return UInt(self)
	}
	
	func toFloat() -> Float {
		return Float(self)
	}
	
    func toCGFloat() -> CGFloat {
		return CGFloat(self)
	}
}

// MARK: - Operators
precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// SwifterSwift: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base double.
///   - rhs: exponent double.
/// - Returns: exponentiation result (example: 4.4 ** 0.5 = 2.0976176963).
public func **(lhs: Double, rhs: Double) -> Double{
	return pow(lhs, rhs)
}


/// SwifterSwift: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base float.
///   - rhs: exponent float.
/// - Returns: exponentiation result (4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Float, rhs: Float) -> Float {
	// http://nshipster.com/swift-operators/
	return pow(lhs, rhs)
}
