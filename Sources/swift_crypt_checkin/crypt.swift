import Foundation

func CFStringFromString(_ name: String) -> Foundation.CFString {
    let ns = name as NSString
    return ns as CFString
}

func StringFromCFString(_ name: Foundation.CFString) -> String {
    let s = name as NSString
    return s as String

}

class CryptPreferences {

    public var Domain: String
    public var RemovePlist: Bool
    public var RotateUsedKey: Bool
    public var OutputPath: String
    public var ValidateKey: Bool
    public var KeyEscrowInterval: Int
    public var AdditionalCurlOpts: [String]

    init(Domain: String) {
        // default values if not already set
        self.Domain = Domain
        self.RotateUsedKey = true
        self.RemovePlist = true
        self.OutputPath = "/private/var/root/crypt_output.plist"
        self.ValidateKey = true
        self.KeyEscrowInterval = 0
        self.AdditionalCurlOpts = []

        let props = ["RotateUsedKey", "RemovePlist", "OutputPath", 
                     "ValidateKey", "KeyEscrowInterval", "AdditionalCurlOpts"]
        for (_, p) in props.enumerated() {
            let pref = self.get_pref(name: p)
            if pref == nil {
                // if preference isn't set, set to default
                self.set_pref(
                    name: p, 
                    value: self.valueByPropertyName(p) as CFPropertyList
                )
            } else {
                // if preference is already set, set class var to match
                self.setValueByPropertyName(
                    name: p, 
                    value: pref)
            }
        }
    }

    public func get_pref(name: String) -> Foundation.CFPropertyList? {
        let pref = Foundation.CFPreferencesCopyAppValue(
            CFStringFromString(name), 
            CFStringFromString(self.Domain)
        )
        return pref
    }

    public func set_pref(name: String, value: Foundation.CFPropertyList?) {
        let cfdomain = CFStringFromString(self.Domain)
        Foundation.CFPreferencesSetValue(
            CFStringFromString(name), 
            value, 
            cfdomain, 
            Foundation.kCFPreferencesAnyUser, 
            Foundation.kCFPreferencesCurrentHost)
        Foundation.CFPreferencesAppSynchronize(cfdomain)
    }

    public func delete_pref(name: String) {
        let cfdomain = CFStringFromString(self.Domain)
        Foundation.CFPreferencesSetValue(
            CFStringFromString(name), 
            nil, 
            cfdomain, 
            Foundation.kCFPreferencesAnyUser, 
            Foundation.kCFPreferencesCurrentHost)
        Foundation.CFPreferencesAppSynchronize(cfdomain)
    }

    private func valueByPropertyName(_ name:String) -> Any? {
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

    private func setValueByPropertyName(name: String, value: CFPropertyList?) {
        switch name {
            case "RemovePlist": self.RemovePlist = value as! Bool
            case "RotateUsedKey": self.RotateUsedKey = value as! Bool
            case "OutputPath": self.OutputPath = value as! String
            case "ValidateKey": self.ValidateKey = value as! Bool
            case "KeyEscrowInterval": self.KeyEscrowInterval = value as! CFNumber as! Int
            case "AdditionalCurlOpts": self.AdditionalCurlOpts = value as! [String]
            default: fatalError("Invalid property name")
        }
    }
}



