import Foundation

func CFStringFromString(_ name: String) -> Foundation.CFString {
    let ns = name as NSString
    return ns as CFString
}

func StringFromCFString(_ name: Foundation.CFString) -> String {
    let s = name as NSString
    return s as String
}

func CFPreferencesSync(_ domain: CFString) -> Bool {
    return Foundation.CFPreferencesAppSynchronize(
        domain
    )
}

func get_pref(name: String, domain: CFString) -> Foundation.CFPropertyList? {
    if CFPreferencesSync(domain) {
        NSLog("sync before CopyAppValue succeeded")
    } else {
        fatalError("sync before CopyAppValue failed")
    }
    let pref = Foundation.CFPreferencesCopyValue(
        CFStringFromString(name), 
        domain,
        Foundation.kCFPreferencesAnyUser, 
        Foundation.kCFPreferencesAnyHost
    )
    return pref
}

func delete_pref(name: String, domain: String) -> Bool {
    let cfdomain = CFStringFromString(domain)
    Foundation.CFPreferencesSetValue(
        CFStringFromString(name), 
        nil, 
        cfdomain, 
        Foundation.kCFPreferencesAnyUser, 
        Foundation.kCFPreferencesAnyHost)
    return CFPreferencesSync(cfdomain)
}

class CryptPreferences {

    public var Domain: Foundation.CFString
    public var RemovePlist: Bool?
    public var RotateUsedKey: Bool?
    public var OutputPath: String?
    public var ValidateKey: Bool?
    public var KeyEscrowInterval: Int?
    public var AdditionalCurlOpts: [String]?

    init(Domain: String) {
        // default values if not already set
        self.Domain = Domain as CFString
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
            let v = self.getValueByPropertyName(p)
            if pref == nil {
                NSLog("\(p) is not set in CFPreferences. Setting to default of \(v!).")
                let setp = self.set_pref(name: p, value: v as CFPropertyList)
                if setp {
                    NSLog("Setting preference succeeded.")
                } else {
                    fatalError("Setting preference failed")
                } 
            } else {
                // if preference is already set, set class var to match
                self.setValueByPropertyName(
                    name: p, 
                    value: pref)
                NSLog("\(p) already set to \(v!).")
            }
        }
    }

    public func get_pref(name: String) -> Foundation.CFPropertyList? {
        if CFPreferencesSync(self.Domain) {
            NSLog("sync before CopyAppValue succeeded")
        } else {
            fatalError("sync before CopyAppValue failed")
        }
        let pref = Foundation.CFPreferencesCopyAppValue(
            CFStringFromString(name), 
            self.Domain
        )
        return pref
    }

    public func set_pref(name: String, value: Foundation.CFPropertyList?) -> Bool {
        Foundation.CFPreferencesSetValue(
            CFStringFromString(name), 
            value, 
            self.Domain, 
            Foundation.kCFPreferencesAnyUser, 
            Foundation.kCFPreferencesAnyHost)
        return CFPreferencesSync(self.Domain)
    }

    public func delete_pref(name: String) -> Bool {
        Foundation.CFPreferencesSetValue(
            CFStringFromString(name), 
            nil, 
            self.Domain, 
            Foundation.kCFPreferencesAnyUser, 
            Foundation.kCFPreferencesAnyHost)
        self.setValueByPropertyName(
            name: name, value: nil)
        return CFPreferencesSync(self.Domain)
    }

    private func getValueByPropertyName(_ name:String) -> Any? {
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
            case "RemovePlist": self.RemovePlist = value as! Bool?
            case "RotateUsedKey": self.RotateUsedKey = value as! Bool?
            case "OutputPath": self.OutputPath = value as! String?
            case "ValidateKey": self.ValidateKey = value as! Bool?
            case "KeyEscrowInterval": self.KeyEscrowInterval = value as! CFNumber as! Int?
            case "AdditionalCurlOpts": self.AdditionalCurlOpts = value as! [String]?
            default: fatalError("Invalid property name")
        }
    }
}



