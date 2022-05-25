//
//  NSRange+YYLib.swift
//  ZiHeBuilding
//
//  Created by MAC on 2022/04/11.
//

import Foundation

//扩展NSRange，添加转换成Range的方法
extension NSRange {
    func toRange(string: String) -> Range<String.Index>
    {
        let startIndex = string.index(string.startIndex, offsetBy: self.location)
        let endIndex = string.index(startIndex, offsetBy: self.length)
        return startIndex..<endIndex
    }
}
