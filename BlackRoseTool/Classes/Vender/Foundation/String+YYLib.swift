//
//  String+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - Subscript
public extension String {
	/// Safely subscript string with index.
	///
	///		"Hello World!"[3] -> "l"
	///		"Hello World!"[20] -> nil
	///
	/// - Parameter i: index.
	subscript(safe i: Int) -> Character? {
		guard i >= 0 && i < count else { return nil }
		return self[index(startIndex, offsetBy: i)]
	}
	
	/// Safely subscript string within a half-open range.
	///
	///		"Hello World!"[6..<11] -> "World"
	///		"Hello World!"[21..<110] -> nil
	///
	/// - Parameter range: Half-open range.
	subscript(range: CountableRange<Int>) -> String? {
		guard
			let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex),
			let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else {
				return nil
		}
		return String(self[lowerIndex..<upperIndex])
	}
	
	/// Safely subscript string within a closed range.
	///
	///		"Hello World!"[6...11] -> "World!"
	///		"Hello World!"[21...110] -> nil
	///
	/// - Parameter range: Closed range.
	subscript(range: ClosedRange<Int>) -> String? {
		guard
			let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex),
			let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else {
				return nil
		}
		return String(self[lowerIndex..<upperIndex])
	}
	
	/// EZSE: Cut string from integerIndex to the end
	subscript(integerIndex: Int) -> Character {
		let idx = index(startIndex, offsetBy: integerIndex)
		return self[idx]
	}
}

extension String: Error {
    
}

// MARK: - Static
public extension String {
	/// Random string of given length.
	///
	///		String.random(length: 18) -> "u7MMZYvGo9obcOcPj8"
	///
	/// - Parameter length: number of characters in string.
	/// - Returns: random string of given length.
	static func random(length: Int, base: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
		guard length > 0 else { return "" }
		var randomString = ""
		for _ in 1...length {
			let randomIndex = arc4random_uniform(UInt32(base.count))
			let randomCharacter = base.charactersArray()[Int(randomIndex)]
			randomString.append(randomCharacter)
		}
		return randomString
	}
	
	static func randomNum(length: Int) -> String {
		return random(length: length, base: "0123456789")
	}
}

// MARK: - 文件相关
public extension String {
    var fileSize: UInt {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: self) else {
            return 0
        }
        return (attrs[.size] as? UInt) ?? 0
    }
    
	static func documentPath() -> String {
		return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
	}
	
	func resourcePath() -> String? {
		return Bundle.main.path(forResource: self, ofType: nil)
	}
	
	func resourceContentData() -> Data? {
		return resourcePath().flatMap { try? Data(contentsOf: $0.toFileURL()) }
	}
	
	func resourceContentString(encoding: Encoding = .utf8) -> String? {
		return resourcePath().flatMap { try? String(contentsOfFile: $0, encoding: encoding) }
	}
}

// MARK: - Check
public extension String {
	/// nil, @"", @"  ", @"\n" will Returns YES; otherwise Returns NO.
	var isBlank: Bool {
		return trimmed.isEmpty
	}
	
	/// nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
	var isNotBlank: Bool {
		return !trimmed.isEmpty
	}
	
	/// Check if string contains one or more emojis.
	///
	///		"Hello 😀".containEmoji -> true
	///
	var containEmoji: Bool {
		// http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
		for scalar in unicodeScalars {
			switch scalar.value {
			case 0x3030, 0x00AE, 0x00A9, // Special Characters
			0x1D000...0x1F77F, // Emoticons
			0x2100...0x27BF, // Misc symbols and Dingbats
			0xFE00...0xFE0F, // Variation Selectors
			0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
				return true
			default:
				continue
			}
		}
		return false
	}
	
	/// Check if string contains one or more letters.
	///
	///		"123abc".hasLetters -> true
	///		"123".hasLetters -> false
	///
	var hasLetters: Bool {
		return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
	}
	
	/// Check if string contains only letters.
	///
	///		"abc".hasLettersOnly -> true
	///		"123abc".hasLettersOnly -> false
	///
	var hasLettersOnly: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		return hasLetters && !hasNumbers
	}
	
	/// Check if string contains one or more numbers.
	///
	///		"abcd".hasNumbers -> false
	///		"123abc".hasNumbers -> true
	///
	var hasNumbers: Bool {
		return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
	}
	
	/// SwifterSwift: Check if string is a valid Swift number.
	///
	/// Note:
	/// In North America, "." is the decimal separator,
	/// while in many parts of Europe "," is used,
	///
	///		"123".isNumeric -> true
	///     "1.3".isNumeric -> true (en_US)
	///     "1,3".isNumeric -> true (fr_FR)
	///		"abc".isNumeric -> false
	///
	var isNumeric: Bool {
		let scanner = Scanner(string: self)
		scanner.locale = NSLocale.current
		return scanner.scanDecimal(nil) && scanner.isAtEnd
	}
	
	/// SwifterSwift: Check if string only contains digits.
	///
	///     "123".isDigits -> true
	///     "1.3".isDigits -> false
	///     "abc".isDigits -> false
	///
	var isDigits: Bool {
		return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
	}
    
    var isValidPhoneNumber: Bool {
        let regex = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
	
	/// Check if string is valid email format.
	///
	///		"john@doe.com".isEmail -> true
	///
	var isValidEmail: Bool {
		// http://emailregex.com/
		let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
		return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}
	
	/// Check if string is a valid URL.
	///
	///		"https://google.com".isValidUrl -> true
	///
	var isValidUrl: Bool {
		return URL(string: self) != nil
	}
	
	/// Check if string is a valid schemed URL.
	///
	///		"https://google.com".isValidSchemedUrl -> true
	///		"google.com".isValidSchemedUrl -> false
	///
	var isValidSchemedUrl: Bool {
		guard let url = URL(string: self) else { return false }
		return url.scheme != nil
	}
	
	/// Check if string is a valid https URL.
	///
	///		"https://google.com".isValidHttpsUrl -> true
	///
	var isValidHttpsUrl: Bool {
		guard let url = URL(string: self) else { return false }
		return url.scheme == "https"
	}
	
	/// Check if string is a valid http URL.
	///
	///		"http://google.com".isValidHttpUrl -> true
	///
	var isValidHttpUrl: Bool {
		guard let url = URL(string: self) else { return false }
		return url.scheme == "http"
	}
	
	/// Check if string is a valid file URL.
	///
	///		"file://Documents/file.txt".isValidFileUrl -> true
	///
	var isValidFileUrl: Bool {
		return URL(string: self)?.isFileURL ?? false
	}
    
    var isValidIP: Bool {
        let regex = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isValidPort: Bool {
        let port = Int(self) ?? 0
        return port > 0 && port < 65536
    }
	
	/// Check if string contains one or more instance of substring.
	///
	///		"Hello World!".contain("O") -> false
	///		"Hello World!".contain("o", caseSensitive: false) -> true
	///
	/// - Parameters:
	///   - string: substring to search for.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: true if string contains one or more instance of substring.
	func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return range(of: string, options: .caseInsensitive) != nil
		}
		return range(of: string) != nil
	}
	
	/// SwifterSwift: Check if string ends with substring.
	///
	///		"Hello World!".end(with: "!") -> true
	///		"Hello World!".end(with: "WoRld!", caseSensitive: false) -> true
	///
	/// - Parameters:
	///   - suffix: substring to search if string ends with.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: true if string ends with substring.
	func end(with suffix: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return lowercased().hasSuffix(suffix.lowercased())
		}
		return hasSuffix(suffix)
	}
	
	func begin(with prefix: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return lowercased().hasPrefix(prefix.lowercased())
		}
		return hasPrefix(prefix)
	}
	
	/// Verify if string matches the regex pattern.
	///
	/// - Parameter pattern: Pattern to verify.
	/// - Returns: true if string matches the pattern.
	func matches(pattern: String) -> Bool {
		return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
	}
	
	/// Check if string contains only unique characters.
	///
	func hasUniqueCharacters() -> Bool {
		guard count > 0 else { return false }
		var uniqueChars = Set<String>()
		for char in self {
			if uniqueChars.contains(String(char)) { return false }
			uniqueChars.insert(String(char))
		}
		return true
	}
}

// MARK: - 编码相关
public extension String {
	/// URL escaped string.
	///
	///		"it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
	///
	func urlEncoded(characterSet: CharacterSet = .urlHostAllowed) -> String {
		return addingPercentEncoding(withAllowedCharacters: characterSet) ?? self
	}
	
	/// Readable string from a URL string.
	///
	///		"it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
	///
	func urlDecoded() -> String {
		return removingPercentEncoding ?? self
	}
	
	/// String encoded in base64 (if applicable).
	///
	///		"Hello World!".base64Encoded() -> Optional("SGVsbG8gV29ybGQh")
	///
	func base64Encoded(options: Data.Base64EncodingOptions = .lineLength64Characters) -> String {
		return Data(utf8).base64EncodedString(options: options)
	}
	
	/// String decoded from base64 (if applicable).
	///
	///		"SGVsbG8gV29ybGQh".base64Decoded() = Optional("Hello World!")
	///
	func base64Decoded(encoding: String.Encoding = .utf8) -> String? {
		return base64DecodedData().flatMap { String(data: $0, encoding: encoding) }
	}
	
	func base64EncodedData(options: Data.Base64EncodingOptions = .lineLength64Characters) -> Data? {
		return data(using: .utf8).flatMap { $0.base64EncodedData(options: options) }
	}
	
	func base64DecodedData(options: NSData.Base64DecodingOptions = .ignoreUnknownCharacters) -> Data? {
		return Data(base64Encoded: self, options: options)
	}
	
	func unicodeString() -> String? {
		guard let cString = cString(using: .nonLossyASCII) else {
			return nil
		}
		return String(cString: cString, encoding: .utf8)
	}
	
	func deUnicodeString() -> String? {
		guard let cString = cString(using: .utf8) else {
			return nil
		}
		return String(cString: cString, encoding: .nonLossyASCII)
	}
	
	var md5: String{
		return self
	}
}

// MARK: - Convert String
public extension String {
    /// 判断是否含有中文
    func hasChinese() -> Bool {
        for value in self {
            if value >= "\u{4E00}" && value <= "\u{9FA5}" {
                return true
            }
        }
        
        return false
    }
    
    /// 汉字 -> 拼音
    func chineseToPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        /// 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false)
        /// 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        
        return stringRef as String
    }
    
	/// String with no spaces or new lines in beginning and end.
	///
	///		"   hello  \n".trimmed -> "hello"
	///
	var trimmed: String {
		return trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	mutating func trim() {
		self = trimmed
	}
	
	/// String without spaces and new lines.
	///
	///		"   \n Swifter   \n  Swift  ".withoutBlank -> "SwifterSwift"
	///
	var withoutBlank: String {
		return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
	}
	
	/// Reverse string.
	var reversedString: String {
		return String(reversed())
	}
	
	mutating func reverse() {
		self = reversedString
	}
	
	/// CamelCase of string. 转驼峰
	///
	///		"sOme vAriable naMe".camelCased -> "someVariableName"
	var camelCased: String {
		let source = lowercased()
		let first = source[..<source.index(after: source.startIndex)]
		if source.contains(" ") {
			let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
			let camel = connected.replacingOccurrences(of: "\n", with: "")
			let rest = String(camel.dropFirst())
			return first + rest
		}
		let rest = String(source.dropFirst())
		return first + rest
	}
	
	/// First character of string (if applicable).
	///
	///		"Hello".firstString -> Optional("H")
	///		"".firstString -> nil
	///
	var firstString: String? {
		return first.flatMap{ String($0) }
	}
	
	/// SwifterSwift: Last character of string (if applicable).
	///
	///		"Hello".lastString -> Optional("o")
	///		"".lastString -> nil
	///
	var lastString: String? {
		return last.flatMap{ String($0) }
	}
	
	/// SwifterSwift: First character of string uppercased(if applicable) while keeping the original string.
	///
	///        "hello world".firstCharacterUppercased() -> "Hello world"
	///        "".firstCharacterUppercased() -> ""
	///
	mutating func firstCharacterUppercased() {
		guard let first = first else { return }
		self = String(first).uppercased() + dropFirst()
	}
	
	/// Latinized string.
	///
	///		"Hèllö Wórld!".latinized -> "Hello World!"
	///
	var latinized: String {
		return folding(options: .diacriticInsensitive, locale: Locale.current)
	}
	
	/// Array of strings separated by new lines.
	///
	///		"Hello\ntest".lines() -> ["Hello", "test"]
	///
	/// - Returns: Strings separated by new lines.
	func lines() -> [String] {
		var result = [String]()
		enumerateLines { line, _ in
			result.append(line)
		}
		return result
	}
	
	/// an array of all words in a string
	///
	///		"Swift is amazing".words() -> ["Swift", "is", "amazing"]
	///
	/// - Returns: The words contained in a string.
	func words() -> [String] {
		// https://stackoverflow.com/questions/42822838
		let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
		let comps = components(separatedBy: chararacterSet)
		return comps.filter { !$0.isEmpty }
	}
	
	/// Returns a localized string, with an optional comment for translators.
	///
	///        "Hello world".localized -> Hallo Welt
	///
    func localized(tableName: String? = nil, comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, comment: comment)
	}
}

// MARK: - Convert Other
public extension String {
	func toClass() -> AnyClass? {
		if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
			let classStringName = "_TtC\(appName.count)\(appName)\(count)\(self)"
			return NSClassFromString(classStringName)
		}
		return nil;
	}
	
	#if os(iOS)
	func toNib() -> UINib {
		return UINib(nibName: self, bundle: nil)
	}
	
    func toImage(in bundle: Bundle? = nil) -> UIImage? {
		return UIImage(named: self, in: bundle, compatibleWith: nil)
	}
	#endif
	
	func toData(encoding: Encoding = .utf8) -> Data? {
		return data(using: .utf8)
	}
	
	func toURL() -> URL? {
		return URL(string: self)
	}
	
	func toFileURL() -> URL {
		return URL(fileURLWithPath: self)
	}
	
	/// Date object from "yyyy-MM-dd" formatted string.
	///
	///		"2007-06-29".toDate() -> Optional(Date)
	///
	func toDate(format: String = "yyyy-MM-dd") -> Date? {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = format
		return formatter.date(from: trimmed)
	}
	
	/// Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
	///
	///		"2007-06-29 14:23:09".toDateWithTime() -> Optional(Date)
	///
	func toDateWithTime() -> Date? {
		return toDate(format: "yyyy-MM-dd HH:mm:ss")
	}
	
	/// Bool value from string (if applicable).
	///
	///		"1".bool -> true
	///		"False".bool -> false
	///		"Hello".bool = nil
	///
	func toBool() -> Bool? {
		let selfLowercased = trimmed.lowercased()
		if selfLowercased == "true" || selfLowercased == "1" {
			return true
		} else if selfLowercased == "false" || selfLowercased == "0" {
			return false
		}
		return nil
	}
	
	/// Integer value from string (if applicable).
	///
	///		"101".toInt() -> 101
	///
	func toInt() -> Int? {
		return Int(self)
	}
	
	func toInt8() -> Int8? {
		return Int8(self)
	}
	
	func toInt32() -> Int32? {
		return Int32(self)
	}
	
	func toInt64() -> Int64? {
		return Int64(self)
	}
	
	func toUInt() -> UInt? {
		return UInt(self)
	}
	
	func toDouble(locale: Locale = .current) -> Double? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self) as? Double
	}
	
	func toFloat(locale: Locale = .current) -> Float? {
//		let formatter = NumberFormatter()
//		formatter.locale = locale
//		formatter.allowsFloats = true
//		return formatter.number(from: self) as? Float
        return Float(self)
	}
	
	func toCGFloat(locale: Locale = .current) -> CGFloat? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self) as? CGFloat
	}
}

// MARK: - Character
public extension String {
	/// Array of characters of a string.
	///
	func charactersArray() -> [Character] {
		return Array(self)
	}
	
	/// The most common character in string.
	///
	///		"This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
	///
	/// - Returns: The most common character.
	func mostCommonCharacter() -> Character? {
		let mostCommon = withoutBlank.reduce(into: [Character: Int]()) {
			let count = $0[$1] ?? 0
			$0[$1] = count + 1
			}.max { $0.1 < $1.1 }?.0
		
		return mostCommon
	}
}

// MARK: - SubString
public extension String {
    var digits: String {
        return filter { $0 >= "0" && $0 <= "9" }
    }
    
    mutating func removeSubString(_ sub: String) {
        if let subRang = range(of: sub) {
            removeSubrange(subRang)
        }
    }
    
	/// SwifterSwift: Count of substring in string.
	///
	///		"Hello World!".count(of: "o") -> 2
	///		"Hello World!".count(of: "L", caseSensitive: false) -> 3
	///
	/// - Parameters:
	///   - string: substring to search for.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: count of appearance of substring in string.
	func count(of string: String, caseSensitive: Bool = true) -> Int {
		if !caseSensitive {
			return lowercased().components(separatedBy: string.lowercased()).count - 1
		}
		return components(separatedBy: string).count - 1
	}
	
	// swiftlint:disable next identifier_name
	/// SwifterSwift: Sliced string from a start index with length.
	///
	///        "Hello World".slicing(from: 6, length: 5) -> "World"
	///
	/// - Parameters:
	///   - i: string index the slicing should start from.
	///   - length: amount of characters to be sliced after given index.
	/// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
	func slicing(from i: Int, length: Int) -> String? {
		guard length >= 0, i >= 0, i < count  else { return nil }
		guard i.advanced(by: length) <= count else {
			return self[i..<count]
		}
		guard length > 0 else { return "" }
		return self[i..<i.advanced(by: length)]
	}
	
	// swiftlint:disable next identifier_name
	/// SwifterSwift: Slice given string from a start index with length (if applicable).
	///
	///		var str = "Hello World"
	///		str.slice(from: 6, length: 5)
	///		print(str) // prints "World"
	///
	/// - Parameters:
	///   - i: string index the slicing should start from.
	///   - length: amount of characters to be sliced after given index.
	mutating func slice(from i: Int, length: Int) {
		if let str = self.slicing(from: i, length: length) {
			self = String(str)
		}
	}
	
	/// SwifterSwift: Slice given string from a start index to an end index (if applicable).
	///
	///		var str = "Hello World"
	///		str.slice(from: 6, to: 11)
	///		print(str) // prints "World"
	///
	/// - Parameters:
	///   - start: string index the slicing should start from.
	///   - end: string index the slicing should end at.
	mutating func slice(from start: Int, to end: Int) {
		guard end >= start else { return }
		if let str = self[start..<end] {
			self = str
		}
	}
	
	// swiftlint:disable next identifier_name
	/// SwifterSwift: Slice given string from a start index (if applicable).
	///
	///		var str = "Hello World"
	///		str.slice(at: 6)
	///		print(str) // prints "World"
	///
	/// - Parameter i: string index the slicing should start from.
	mutating func slice(at i: Int) {
		guard i < count else { return }
		if let str = self[i..<count] {
			self = str
		}
	}
	
	/// SwifterSwift: Truncate string (cut it to a given number of characters).
	///
	///		var str = "This is a very long sentence"
	///		str.truncate(toLength: 14)
	///		print(str) // prints "This is a very..."
	///
	/// - Parameters:
	///   - toLength: maximum number of characters before cutting.
	///   - trailing: string to add at the end of truncated string (default is "...").
	mutating func truncate(toLength length: Int, trailing: String? = "...") {
		guard length > 0 else { return }
		if count > length {
			self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
		}
	}
	
	/// SwifterSwift: Removes given prefix from the string.
	///
	///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
	///
	/// - Parameter prefix: Prefix to remove from the string.
	/// - Returns: The string after prefix removing.
	func removingPrefix(_ prefix: String) -> String {
		guard hasPrefix(prefix) else { return self}
		return String(dropFirst(prefix.count))
	}
	
	/// SwifterSwift: Removes given suffix from the string.
	///
	///   "Hello, World!".removingSuffix(", World!") -> "Hello"
	///
	/// - Parameter suffix: Suffix to remove from the string.
	/// - Returns: The string after suffix removing.
	func removingSuffix(_ suffix: String) -> String {
		guard hasSuffix(suffix) else { return self }
		return String(dropLast(suffix.count))
	}
}

// MARK: - Operators
public extension String {
	/// Repeat string multiple times.
	///
	///		'bar' * 3 -> "barbarbar"
	///
	/// - Parameters:
	///   - lhs: string to repeat.
	///   - rhs: number of times to repeat character.
	/// - Returns: new string with given string repeated n times.
	static func *(lhs: String, rhs: Int) -> String {
		guard rhs > 0 else { return "" }
		return String(repeating: lhs, count: rhs)
	}
	
	/// Repeat string multiple times.
	///
	///		3 * 'bar' -> "barbarbar"
	///
	/// - Parameters:
	///   - lhs: number of times to repeat character.
	///   - rhs: string to repeat.
	/// - Returns: new string with given string repeated n times.
	static func * (lhs: Int, rhs: String) -> String {
		guard lhs > 0 else { return "" }
		return String(repeating: rhs, count: lhs)
	}
}

// MARK: - NSString extensions
public extension String {
	/// NSString from a string.
	var nsString: NSString {
		return self as NSString
//		return NSString(string: self)
	}
	
	/// NSString lastPathComponent.
	var lastPathComponent: String {
		return (self as NSString).lastPathComponent
	}
	
	/// NSString pathExtension.
	var pathExtension: String {
		return (self as NSString).pathExtension
	}
	
	/// NSString deletingLastPathComponent.
	var deletingLastPathComponent: String {
		return (self as NSString).deletingLastPathComponent
	}
	
	/// NSString deletingPathExtension.
	var deletingPathExtension: String {
		return (self as NSString).deletingPathExtension
	}
	
	/// NSString pathComponents.
	var pathComponents: [String] {
		return components(separatedBy: "/")
	}
	
	/// NSString appendingPathComponent(str: String)
	///
	/// - Parameter str: the path component to append to the receiver.
	/// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
	func appendingPathComponent(_ str: String) -> String {
		return (self as NSString).appendingPathComponent(str)
	}
	
	/// NSString appendingPathExtension(str: String)
	///
	/// - Parameter str: The extension to append to the receiver.
	/// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
	func appendingPathExtension(_ str: String) -> String {
		return (self as NSString).appendingPathExtension(str) ?? self
	}
	/*
	/Users/caoxu/Documents
	
	/Users/caoxu/Documents/test			appendingPathComponent(test)
	/Users/caoxu/Documents/test.plist 	appendingPathExtension(plist)
	*/
}

// MARK: -
extension String {
	#if os(iOS) || os(macOS)
	/// SwifterSwift: Copy string to global pasteboard.
	///
	///		"SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
	///
	func copyToPasteboard() {
		#if os(iOS)
			UIPasteboard.general.string = self
		#elseif os(macOS)
			NSPasteboard.general.clearContents()
			NSPasteboard.general.setString(self, forType: .string)
		#endif
	}
	#endif
}






// 计算文字高度或者宽度与weight参数无关
extension String {
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15, maxWidth: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)>maxWidth ? maxWidth : ceil(rect.width)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
}







