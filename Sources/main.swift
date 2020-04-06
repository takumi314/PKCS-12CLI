import Foundation

let currentDir = FileManager.default.currentDirectoryPath
let arguments = CommandLine.arguments

// -h
for ( _, argument) in arguments.enumerated() {
    if argument.contains("-h") || argument.contains("-H") {
        print("Usage:\n\n    $ p12_importer {file_path} [Option] {password}\n\nOptions:\n    -h   Help\n    -H   Help\n    -p   Pasword phrase\n\n")
        exit(1)
    }
}

// .p12 or .mobileprovision
var filePath = ""
for (i, argument) in arguments.enumerated() {
    if argument.hasSuffix(".p12") {
        let fileName = arguments[i]
        print("fileName: \(fileName)")
        filePath = (currentDir as NSString).appendingPathComponent(fileName)
        print("filePath: \(filePath)")
        break
    }
}

if filePath.isEmpty {
    print("Could not find any file.\np12_importer {file_path} [-p] {password}")
    exit(1)
}

let url = URL(fileURLWithPath: filePath)
let data = try Data(contentsOf: url)
print("data: \(data)")

// -p
var password = ""
for (i, argument) in arguments.enumerated() {
    if argument == "-p" {
        let nextIndex = i + 1
        if arguments.count > nextIndex {
            password = arguments[nextIndex]
            let blind_password = (0..<password.count).map({ _ in "*" }).joined()
            print("Password: \(blind_password)")
            break
        }
    }
}
if password.isEmpty {
    print("No password. Please try again.\np12_importer {file_path} [-p] {password}")
    exit(1)
}

let options = [kSecImportExportPassphrase as String: password]

var rawItems: CFArray?
let status = SecPKCS12Import(data as CFData, options as CFDictionary, &rawItems)

guard status == errSecSuccess else {
    print("failed importing p12 file. [status: \(status)] \np12_importer {file_path} [-p] {password}")
    exit(1)
}

let items = rawItems! as! Array<Dictionary<String, Any>>
let firstItem = items[0]
print(firstItem)

let identity = firstItem[kSecImportItemIdentity as String] as! SecIdentity?
print("identity: \(identity ?? "" as! SecIdentity)")
