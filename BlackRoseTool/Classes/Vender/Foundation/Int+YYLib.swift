//
//  Int+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import CoreGraphics
import Foundation

// MARK: - SignedInteger
// MARK: - Properties
public extension SignedInteger {
    
    /// SwifterSwift: Absolute value of integer number.
    var abs: Self {
        return Swift.abs(self)
    }
    
    /// SwifterSwift: Check if integer is positive.
    var isPositive: Bool {
        return self > 0
    }
    
    /// SwifterSwift: Check if integer is negative.
    var isNegative: Bool {
        return self < 0
    }
    
    /// SwifterSwift: Check if integer is even.
    var isEven: Bool {
        return (self % 2) == 0
    }
    
    /// SwifterSwift: Check if integer is odd.
    var isOdd: Bool {
        return (self % 2) != 0
    }
    
    /// SwifterSwift: String of format (XXh XXm) from seconds Int.
    var timeString: String {
        guard self > 0 else {
            return "0 sec"
        }
        if self < 60 {
            return "\(self) sec"
        }
        if self < 3600 {
            return "\(self / 60) min"
        }
        let hours = self / 3600
        let mins = (self % 3600) / 60
        
        if hours != 0 && mins == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(mins)m"
    }
    
}

// MARK: - Methods
public extension SignedInteger {
    
    // swiftlint:disable next identifier_name
    /// SwifterSwift: Greatest common divisor of integer value and n.
    ///
    /// - Parameter n: integer value to find gcd with.
    /// - Returns: greatest common divisor of self and n.
    func gcd(of n: Self) -> Self {
        return n == 0 ? self : n.gcd(of: self % n)
    }
    
    // swiftlint:disable next identifier_name
    /// SwifterSwift: Least common multiple of integer and n.
    ///
    /// - Parameter n: integer value to find lcm with.
    /// - Returns: least common multiple of self and n.
    func lcm(of n: Self) -> Self {
        return (self * n).abs / gcd(of: n)
    }
    
    /// SwifterSwift: Ordinal representation of an integer.
    ///
    ///        print((12).ordinalString()) // prints "12th"
    ///
    /// - Parameter locale: locale, default is .current.
    /// - Returns: string ordinal representation of number in specified locale language. E.g. input 92, output in "en": "92nd".
    @available(iOS 9.0, macOS 10.11, *)
    func ordinalString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .ordinal
        guard let number = self as? NSNumber else { return nil }
        return formatter.string(from: number)
    }
}

// MARK: - Int
public extension Int {
    static func random(min: Int = .min, max: Int = .max) -> Int {
        return random(in: min...max)
    }
}

// MARK: - Properties
public extension Int {
    /// CountableRange 0..<Int.
    var countableRange: CountableRange<Int> {
        return 0..<self
    }
    
    /// CountableClosedRange 0...Int.
    var closedRange: CountableClosedRange<Int> {
        return 0...self
    }
    
    /// SwifterSwift: Radian value of degree input.
    var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
    /// SwifterSwift: Degree value of radian input
    var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
    
    /// SwifterSwift: String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..)
    var kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = Swift.abs(self)
        if abs == 0 {
            return "0k"
        } else if abs >= 0 && abs < 1000 {
            return "0k"
        } else if abs >= 1000 && abs < 1000000 {
            return String(format: "\(sign)%ik", abs / 1000)
        }
        return String(format: "\(sign)%ikk", abs / 100000)
    }
    
    /// SwifterSwift: Array of digits of integer value.
    var digits: [Int] {
        guard self != 0 else { return [0] }
        var digits = [Int]()
        var number = self.abs
        
        while number != 0 {
            let xNumber = number % 10
            digits.append(xNumber)
            number /= 10
        }
        
        digits.reverse()
        return digits
    }
    
    /// SwifterSwift: Number of digits of integer value.
    var digitsCount: Int {
        guard self != 0 else { return 1 }
        let number = Double(self.abs)
        return Int(log10(number) + 1)
    }
}


public extension Int {
    /// check if given integer prime or not.
    /// Warning: Using big numbers can be computationally expensive!
    /// - Returns: true or false depending on prime-ness
    func isPrime() -> Bool {
        // To improve speed on latter loop :)
        if self == 2 {
            return true
        }
        
        guard self > 1 && self % 2 != 0 else {
            return false
        }
        // Explanation: It is enough to check numbers until
        // the square root of that number. If you go up from N by one,
        // other multiplier will go 1 down to get similar result
        // (integer-wise operation) such way increases speed of operation
        let base = Int(sqrt(Double(self)))
        for i in Swift.stride(from: 3, through: base, by: 2) where self % i == 0 {
            return false
        }
        return true
    }
    
    /// Roman numeral string from integer (if applicable).
    ///
    ///		10.romanNumeral() -> "X"
    ///
    /// - Returns: The roman numeral string.
    func romanNumeral() -> String? {
        // https://gist.github.com/kumo/a8e1cb1f4b7cff1548c7
        guard self > 0 else { // there is no roman numerals for 0 or negative numbers
            return nil
        }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        var romanValue = ""
        var startingValue = self
        
        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            if div > 0 {
                for _ in 0..<div {
                    romanValue += romanChar
                }
                startingValue -= arabicValue * div
            }
        }
        return romanValue
    }
    
    func toBool() -> Bool {
        return self == 0 ? false : true
    }
    
    func toUInt() -> UInt {
        return UInt(self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func toString() -> String {
        return "\(self)"
    }
    
    func toArray(containsZero: Bool = false) -> [Int] {
        var arr = Array(closedRange)
        if !containsZero {
            arr.removeFirst()
        }
        
        return arr
    }
}

// MARK: - Operators

/// SwifterSwift: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base integer.
///   - rhs: exponent integer.
/// - Returns: exponentiation result (example: 2 ** 3 = 8).
public func ** (lhs: Int, rhs: Int) -> Double {
    // http://nshipster.com/swift-operators/
    return pow(Double(lhs), Double(rhs))
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^ : PowerPrecedence

/// Value of exponentiation.
///
/// - Parameters:
///   - lhs: base integer.
///   - rhs: exponent integer.
/// - Returns: exponentiation result (example: 2 ^ 3 = 8).
public func ^ (lhs: Int, rhs: Int) -> Double {
    // http://nshipster.com/swift-operators/
    return pow(Double(lhs), Double(rhs))
}























