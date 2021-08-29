import Foundation

func CFStringFromString(_ name: String) -> Foundation.CFString {
    let ns = name as NSString
    return ns as CFString
}

func StringFromCFString(_ name: Foundation.CFString) -> String {
    let s = name as NSString
    return s as String

}

func get_pref(name: String, domain: String) -> Foundation.CFPropertyList? {
    let pref = Foundation.CFPreferencesCopyAppValue(
        CFStringFromString(name), 
        CFStringFromString(domain)
    )
    return pref
}

func set_pref(name: String, value: Foundation.CFPropertyList?, domain: String) {
    let cfdomain = CFStringFromString(domain)
    Foundation.CFPreferencesSetValue(
        CFStringFromString(name), 
        value, 
        cfdomain, 
        Foundation.kCFPreferencesAnyUser, 
        Foundation.kCFPreferencesCurrentHost)
    Foundation.CFPreferencesAppSynchronize(cfdomain)
}

func delete_pref(name: String, domain: String) {
    let cfdomain = CFStringFromString(domain)
    Foundation.CFPreferencesSetValue(
        CFStringFromString(name), 
        nil, 
        cfdomain, 
        Foundation.kCFPreferencesAnyUser, 
        Foundation.kCFPreferencesCurrentHost)
    Foundation.CFPreferencesAppSynchronize(cfdomain)
}

public struct CryptPreferences {

    public var Domain: String
    public var RemovePlist: Bool
    public var RotateUsedKey: Bool
    public var OutputPath: String
    public var ValidateKey: Bool
    public var KeyEscrowInterval: Int
    public var AdditionalCurlOpts: [String]

    public func valueByPropertyName(_ name:String) -> Any? {
        switch name {
            case "RemovePlist": return self.RemovePlist
            case "RotateUsedKey": return self.RotateUsedKey
            case "OutputPath": return self.OutputPath
            case "ValidateKey": return self.ValidateKey
            case "KeyEscrowInterval": return self.KeyEscrowInterval
            case "AdditionalCurlOpts": return self.AdditionalCurlOpts
            default: fatalError("Invalid property name")
        }
    }
    public func get_or_set_default(name: String) -> Foundation.CFPropertyList? {
        let pref = get_pref(name: name, domain: self.Domain)
        if pref != nil {
            NSLog("\(name) is already set to \(pref!). Returning.")
            return pref
        }
        if let prefVal = self.valueByPropertyName(name) as CFPropertyList? {
            NSLog("\(name) not set. Setting default of \(prefVal).")
            set_pref(name: name, value: prefVal, domain: self.Domain)
        } else {
            fatalError("can't cast prefVal")
        }
        
        return get_pref(name: name, domain: self.Domain)
    }
}

// public struct Crypt {

// }



