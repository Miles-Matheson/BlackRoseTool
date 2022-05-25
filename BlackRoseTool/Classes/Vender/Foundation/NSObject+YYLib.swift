//
//  NSObject+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import Foundation

public extension NSObject {
	///
    static var clsName: String {
		return String(describing: self)
	}
	
	var clsName: String {
		return type(of: self).clsName
	}
}

public extension NSObject {
	/// 根据类名来实例化对象
	func instanceFrom(_ className: String) -> AnyObject? {
		if let classType = swiftClassFrom(className) {
			return (classType as! NSObject.Type).init()
		}
		
		return nil
	}
	
	//NSClassFromString 在Swift中已经 no effect
	func swiftClassFrom(_ className: String) -> AnyClass? {
		if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
			// generate the full name of your class (take a look into your "SHCC-swift.h" file)
			let classStringName = "_TtC\(appName.count)\(appName)\(className.count)\(className)"
			let cls: AnyClass?  = NSClassFromString(classStringName)
			//            cls = NSClassFromString("\(appName).\(className)")
			//            assert(cls != nil, "class notfound,please check className")
			return cls
		}
		return nil;
	}
}

public extension NSNumber {
	var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

public extension NSError {
    convenience init(code: Int, message: String?) {
		self.init(domain: "xxxxxx", code: code, userInfo: message.map { [NSLocalizedFailureReasonErrorKey: $0] })
	}

}
