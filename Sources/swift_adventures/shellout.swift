import Foundation

// Copied with <3 from https://github.com/macadmins/nudge/blob/main/Nudge/Utilities/SoftwareUpdate.swift
func shellout(command: String, args: [String]) -> String {
    let task = Process()
    task.launchPath = command
    task.arguments = args
    let outputPipe = Pipe()
    let errorPipe = Pipe()

    task.standardOutput = outputPipe
    task.standardError = errorPipe

    do {
        try task.run()
    } catch {
        return "Error running \(command) with args: \(args)"
    }

    task.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    let output = String(decoding: outputData, as: UTF8.self)
    let error = String(decoding: errorData, as: UTF8.self)

    if task.terminationStatus != 0 {
        return error
    } else {
        return output
    }
 }