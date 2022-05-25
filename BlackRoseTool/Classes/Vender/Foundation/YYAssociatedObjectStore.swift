
//
//  Protocol.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import Foundation

public protocol YYAssociatedObjectStore { }

public extension YYAssociatedObjectStore {
	func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
		return objc_getAssociatedObject(self, key) as? T
	}
	
	func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
		if let obj: T = associatedObject(forKey: key) {
			return obj
		}
		
		let obj = `default`()
		setAssociatedObject(obj, forKey: key)
		return obj
	}
	
	func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
		objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}








