import Foundation

func get_pref(name: String) -> Foundation.CFPropertyList? {
    let pref = Foundation.CFPreferencesCopyAppValue(
        CFStringFromString(name), 
        CFStringFromString(BUNDLE_ID)
    )
    return pref
}

func set_pref(name: String, value: String) {

    Foundation.CFPreferencesSetValue(
        CFStringFromString(name), 
        CFStringFromString(value), 
        CFStringFromString(BUNDLE_ID), 
        Foundation.kCFPreferencesAnyUser, 
        Foundation.kCFPreferencesCurrentHost)
}

