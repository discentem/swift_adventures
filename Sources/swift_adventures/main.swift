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

let outPath = get_pref(name: "OutputPath", domain: BUNDLE_ID)

if outPath != nil {
    print(outPath!)
}

let cryptPrefs = CryptPreferences(
    Domain: BUNDLE_ID,
    RemovePlist: true,
    RotateUsedKey: true,
    OutputPath: "/private/var/root/crypt_output.plist",
    ValidateKey: true,
    KeyEscrowInterval: 0,
    AdditionalCurlOpts: []
)

//delete_pref(name: "RemovePlist", domain: BUNDLE_ID)

let removePlist = cryptPrefs.get_pref_or_set_default(name: "RemovePlist")
print(removePlist!)

let computerName = get_mac_name()
if computerName != nil {
    print(computerName!)
}

print(shellout(command: "/bin/bash", args: ["-c", "/bin/echo hello"]))




