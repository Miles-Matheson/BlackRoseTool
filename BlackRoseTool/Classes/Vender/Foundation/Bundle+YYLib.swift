//
//  Bundle+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import Foundation

public extension Bundle {
	/// EZSE: load xib
	/// Usage: let view: ViewXibName = Bundle.loadNib("ViewXibName")
	class func loadNib<T>(_ name: String) -> T? {
		#if os(macOS)
		return Bundle.main.loadNibNamed(name, owner: nil, topLevelObjects: nil) as? T
		#else
		return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T
		#endif
		
	}
	
	//	func loadFiles(named fileNames: [String]) throws -> [File] {
	//		return
	//	}
}
























