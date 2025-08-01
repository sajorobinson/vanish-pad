import Foundation

// Config

let appName = "VanishPad"
let executableName = appName
let bundleIdentifier = "com.example.\(appName.lowercased())"
let version = "1.0"
let iconFileName = "AppIcon.icns"
let iconSourcePath = "Resources/\(iconFileName)"

// Paths

let fileManager = FileManager.default
let buildOutputDir = ".build/release"
let executablePath = "\(buildOutputDir)/\(executableName)"
let appBundleDir = "\(appName).app"
let contentsDir = "\(appBundleDir)/Contents"
let macOSDir = "\(contentsDir)/MacOS"
let resourcesDir = "\(contentsDir)/Resources"
let plistDestPath = "\(contentsDir)/Info.plist"
let iconDestPath = "\(resourcesDir)/\(iconFileName)"

// Shell runner

func runShell(_ command: String) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    process.arguments = ["-c", command]
    try process.run()
    process.waitUntilExit()
    if process.terminationStatus != 0 {
        throw NSError(domain: "ShellError", code: Int(process.terminationStatus), userInfo: nil)
    }
}

func writePlist(to path: String) throws {
    let plist: [String: Any] = [
        "CFBundleName": appName,
        "CFBundleIdentifier": bundleIdentifier,
        "CFBundleVersion": version,
        "CFBundleExecutable": executableName,
        "CFBundlePackageType": "APPL",
        "NSPrincipalClass": "NSApplication",
        "CFBundleIconFile": iconFileName.replacingOccurrences(of: ".icns", with: ""),
    ]
    let plistData = try PropertyListSerialization.data(
        fromPropertyList: plist, format: .xml, options: 0)
    try plistData.write(to: URL(fileURLWithPath: path))
}

// Build & bundle

do {
    print("Building release executable...")
    try runShell("swift build -c release")

    print("Creating .app bundle structure...")
    try fileManager.createDirectory(atPath: macOSDir, withIntermediateDirectories: true)
    try fileManager.createDirectory(atPath: resourcesDir, withIntermediateDirectories: true)

    print("Copying executable...")
    let executableDestPath = "\(macOSDir)/\(executableName)"
    if fileManager.fileExists(atPath: executableDestPath) {
        try fileManager.removeItem(atPath: executableDestPath)
    }
    try fileManager.copyItem(atPath: executablePath, toPath: executableDestPath)

    print("Generating Info.plist...")
    if fileManager.fileExists(atPath: plistDestPath) {
        try fileManager.removeItem(atPath: plistDestPath)
    }
    try writePlist(to: plistDestPath)

    if fileManager.fileExists(atPath: iconSourcePath) {
        print("Copying app icon...")
        if fileManager.fileExists(atPath: iconDestPath) {
            try fileManager.removeItem(atPath: iconDestPath)
        }
        try fileManager.copyItem(atPath: iconSourcePath, toPath: iconDestPath)
    } else {
        print("Warning: Icon file not found at \(iconSourcePath)")
    }

    print("Build complete. App bundle created at: \(appBundleDir)")
} catch {
    print("Error: \(error)")
    exit(1)
}
