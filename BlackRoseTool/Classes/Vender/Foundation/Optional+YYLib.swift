//
//  Optional+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

//public extension Optional where Wrapped == Collection {
//    var isNilOrEmpty: Bool {
//        return self?.isEmpty ?? true
//    }
//}

// MARK: - Optional
public extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some(_):
            return false
        }
    }
    
    var isNotNil: Bool {
        return !isNil
    }
}

public extension Optional {
    func unwrapped(_ handler: (Wrapped) -> ()) {
        map(handler)
    }
    
    /// SwifterSwift: Get self of default value (if self is nil).
    ///
    ///		let foo: String? = nil
    ///		print(foo.unwrapped(or: "bar")) -> "bar"
    ///
    ///		let bar: String? = "bar"
    ///		print(bar.unwrapped(or: "foo")) -> "bar"
    ///
    /// - Parameter defaultValue: default value to return if self is nil.
    /// - Returns: self if not nil or default value if nil.
    func unwrapped(or defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        // http://www.russbishop.net/improving-optionals
        return self ?? defaultValue()
    }
    
    // SwifterSwift: Gets the wrapped value of an optional. If the optional is `nil`, throw a custom error.
    ///
    ///        let foo: String? = nil
    ///        try print(foo.unwrapped(orThrow: MyError.notFound)) -> error: MyError.notFound
    ///
    ///        let bar: String? = "bar"
    ///        try print(bar.unwrapped(orThrow: MyError.notFound)) -> "bar"
    ///
    /// - Parameter error: The error to throw if the optional is `nil`.
    /// - Returns: The value wrapped by the optional.
    /// - Throws: The error passed in.
    func unwrapped(orThrow errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
    
    /// try watermark(image).flatMap(encrypt).orThrow(Error.preparationFailed)
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
    
    //	let str: String? = nil
    //	let path = str.andThen { $0.toURL() }
    //		.andThen{ $0.path }
    //		.or("none")
    func andThen<T>(_ then: (Wrapped) throws -> T?) rethrows -> T? {
        guard let value = self else {
            return nil
        }
        
        return try then(value)
    }
    
    ///searchBar.text.matching { $0.count > 2 }.matching { $0.hasPrefix("s") }
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self, predicate(value) else {
            return nil
        }
        
        return value
    }
}

public extension Optional {
    /// let str: String? = "appventure"
    /// let count = str.map({ $0.count }, default: 0)
    func map<T>(_ fn: (Wrapped) throws -> T, default: @autoclosure () throws -> T)
        rethrows -> T {
            return try map(fn) ?? `default`()
    }
}

public extension Optional {
    /*
     loadConfiguration()! crash时只有这个错误：
     fatal error: unexpectedly found nil while unwrapping an Optional value
     
     https://www.swiftbysundell.com/posts/handling-non-optional-optionals-in-swift
     loadConfiguration().require(hint: "Verify that Config.JSON is valid")
     如果失败，将给我们以下错误消息：
     fatal error: Required value was nil.
     Debugging hint: Verify that Config.JSON is valid: file /Users/John/AmazingApp/Sources/AppDelegate.swift, line 17
     */
    func require(hint hitExpression: @autoclosure () -> String? = nil,
                 file: StaticString = #file,
                 line: UInt = #line) -> Wrapped {
        guard let unwrapped = self else {
            var message = "Required value was nil in \(file), at line \(line)"
            hitExpression().unwrapped {
                message.append(". Debugging hint: \($0)")
            }
            
            #if !os(Linux)
            let exception = NSException(
                name: .invalidArgumentException,
                reason: message,
                userInfo: nil
            )
            exception.raise()
            #endif
            
            preconditionFailure(message)
        }
        
        return unwrapped
    }
}

#if os(iOS)
///let statusView = cell.accessoryView.get(orSet: TodoItemStatusView())
public extension Optional where Wrapped == UIView {
    mutating func get<T: UIView>(orSet expression: @autoclosure () -> T) -> T {
        guard let view = self as? T else {
            let newView = expression()
            self = newView
            return newView
        }
        
        return view
    }
}
#endif
