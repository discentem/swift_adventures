import Foundation

func CFStringFromString(_ name: String) -> Foundation.CFString {
    let ns = name as NSString
    return ns as CFString
}

func StringFromCFString(_ name: Foundation.CFString) -> String {
    let s = name as NSString
    return s as String

}