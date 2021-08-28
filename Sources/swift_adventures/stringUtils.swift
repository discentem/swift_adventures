import Foundation
func CFStringFromString(_ name: String) -> Foundation.CFString {
    let ns = name as NSString
    let cf = ns as CFString
    return cf
}