import SystemConfiguration
import CoreData
import Foundation
import Logging

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
LoggingSystem.bootstrap(StreamLogHandler.standardError)
let logger = Logger(label: "com.grahamgilbert.cryptcheckin")

let BUNDLE_ID = "com.grahamgilbert.crypt"

let user = get_console_user()
if user != nil {
    print(user!)
}

print(get_os_version())

var cryptPrefs = CryptPreferences(Domain: BUNDLE_ID)

do {
    let msg = try shellout(command: "/bin/bash", args: ["-c", "/bin/echo hello"])
    logger.info("\(msg)")
} catch let err as shelloutError {
    logger.error("\(err.errorDescription!)")
}



