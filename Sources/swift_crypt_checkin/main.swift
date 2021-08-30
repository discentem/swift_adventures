import SystemConfiguration
import CoreData
import Foundation

func get_console_user() -> String? {
    if let name = SCDynamicStoreCopyConsoleUser(nil, nil, nil) {
        return StringFromCFString(name)
    } 
    return nil
}

func get_mac_name() -> String? {
    if let name = Host.current().localizedName {
        return name
    }
    return nil
}

let BUNDLE_ID = "com.grahamgilbert.crypt"

let user = get_console_user()
if user != nil {
    print(user!)
}

print(get_os_version())

let cryptPrefs = CryptPreferences(Domain: BUNDLE_ID)

cryptPrefs.delete_pref(name: "RemovePlist")

cryptPrefs.set_pref(name: "RemovePlist", value: true as CFPropertyList)

print(cryptPrefs.RemovePlist)
print(cryptPrefs.get_pref(name: "RemovePlist")!)

// print(cryptPrefs.RemovePlist)
// print(get_pref(name: "RemovePlist", domain: BUNDLE_ID))


// let computerName = get_mac_name()
// if computerName != nil {
//     print(computerName!)
// }

//print(shellout(command: "/bin/bash", args: ["-c", "/bin/echo hello"]))




