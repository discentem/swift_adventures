import SystemConfiguration
import CoreData
import Foundation

func get_console_user() -> String? {
    var uid: uid_t = 0
    var gid: gid_t = 0

    if let name = SCDynamicStoreCopyConsoleUser(nil, &uid, &gid) {
        return StringFromCFString(name)
    } 

    return nil
}

func get_os_version() -> OSVersion {
    let major = ProcessInfo().operatingSystemVersion.majorVersion
    let minor = ProcessInfo().operatingSystemVersion.minorVersion
    let patch = ProcessInfo().operatingSystemVersion.patchVersion
    return OSVersion(
        major: major,
        minor: minor,
        patch: patch
    )
}

let BUNDLE_ID = "com.grahamgilbert.crypt"

let user = get_console_user()
if user != nil {
    print(user!)
}

print(get_os_version())

let outPath = get_pref(name: "OutputPath")

if outPath != nil {
    print(outPath!)
}

