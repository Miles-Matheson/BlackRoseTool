//
//  YYResponderInteractable.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

///一种基于ResponderChain的对象交互方式
public protocol YYResponderInteractable {
	func dispatchAction(_ named: String, info: Any?)
}

extension UIResponder {
	@objc open func dispatchAction(_ named: String, info: Any?) {
		///默认事件一直往上传递，直到某个UIResponder重载该方法
		next?.dispatchAction(named, info: info)
	}
}
