import Foundation
import os.log

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

extension URLComponents {
    init(scheme: String = "https",
         host: String = "www.google.com",
         path: String = "/search",
         queryItems: [URLQueryItem]) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}
// https://stackoverflow.com/questions/24551816/swift-encode-url
func urlEncode() {
    let scheme = "https"
    let host = "www.google.com"
    let path = "/search"
    let queryItem = URLQueryItem(name: "q", value: "Formula One")


    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.path = path
    urlComponents.queryItems = [queryItem]

    if let url = urlComponents.url {
        print(url)   // "https://www.google.com/search?q=Formula%20One"
    }
}

class CryptPreferences {

    public var Domain: Foundation.CFString
    public var ServerURL: String?
    public var RemovePlist: Bool?
    public var RotateUsedKey: Bool?
    public var OutputPath: String?
    public var ValidateKey: Bool?
    public var KeyEscrowInterval: Int?
    public var AdditionalCurlOpts: [String]?

    init(Domain: String = "com.grahamgilbert.crypt") {
        // default values if not already set
        self.Domain = Domain as CFString
        self.ServerURL = nil
        self.RotateUsedKey = true
        self.RemovePlist = true
        self.OutputPath = "/private/var/root/crypt_output.plist"
        self.ValidateKey = true
        self.KeyEscrowInterval = 0
        self.AdditionalCurlOpts = []

        let props = ["ServerURL", "RotateUsedKey", "RemovePlist", "OutputPath", 
                     "ValidateKey", "KeyEscrowInterval", "AdditionalCurlOpts"]
        for (_, p) in props.enumerated() {
            let pref = self.get_pref(name: p)
            let v = self.getValueByPropertyName(p)
            if pref == nil {
                logger.info("\(p) is not set in CFPreferences. Setting to default of \(v!).")
                let setp = self.set_pref(name: p, value: v as CFPropertyList)
                if setp {
                    logger.debug("Setting preference \(p) to \(v!) succeeded.")
                } else {
                    logger.error("Setting preference \(p) to \(v!) failed!!")
                } 
            } else {
                // if preference is already set, set class var to match
                self.setValueByPropertyName(
                    name: p, 
                    value: pref)
                logger.debug("\(p) already set to \(self.getValueByPropertyName(p)!).")
            }
        }
    }

    public func get_pref(name: String) -> Foundation.CFPropertyList? {
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
            case "ServerURL": return self.ServerURL
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
            case "ServerURL": self.ServerURL = value as! String?
            case "RemovePlist": self.RemovePlist = value as! Bool?
            case "RotateUsedKey": self.RotateUsedKey = value as! Bool?
            case "OutputPath": self.OutputPath = value as! String?
            case "ValidateKey": self.ValidateKey = value as! Bool?
            case "KeyEscrowInterval": self.KeyEscrowInterval = value as! CFNumber as! Int?
            case "AdditionalCurlOpts": self.AdditionalCurlOpts = value as! [String]?
            default: fatalError("Invalid property name")
        }
    }

    public func escrow() -> Bool {
        logger.info("Attempting to escrow key...")
        guard let serverURL = self.ServerURL else {
            logger.warning("ServerURL is not set. Cannot enforce Filevault escrow.")
            return false
        }
        logger.debug("ServerURL set to \(serverURL)")
        var checkinURL: String = ""
        if (serverURL).hasSuffix("/") {
            checkinURL = "\(serverURL)checkin/"
        } else {
            checkinURL = "\(serverURL)/checkin/"
        }

        print(checkinURL)

        return false
    }
}



