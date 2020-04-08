import Foundation
import Commander

/**  Commander Begin  */

let main = command(Option<String>("help", default: "", description: "help"),
                   Option<String>("password", default: "", description: "give its password if p12 file is password protected."),
                   Option<String>("p12", default: "", description: "give p12 file path")) { help, password, p12File  in
                    if p12File.hasSuffix(".p12") && !p12File.isEmpty {
                        print("fileName: \(p12File)")
                        let currentDir = FileManager.default.currentDirectoryPath
                        let filePath = (currentDir as NSString).appendingPathComponent(p12File)
                        print("filePath: \(filePath)")
                        var data: Data!
                        do {
                            data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                            print("data: \(data.description)")
                        } catch {
                            print("Could not find any file. [error: \(error)]")
                            exit(1)
                        }
                        let options = [kSecImportExportPassphrase as String: password]

                        var rawItems: CFArray?
                        let status = SecPKCS12Import(data as CFData, options as CFDictionary, &rawItems)

                        guard status == errSecSuccess else {
                            print("failed importing p12 file. [status: \(status)]")
                            exit(1)
                        }

                        let items = rawItems! as! Array<Dictionary<String, Any>>
                        let firstItem = items[0]
                        print(firstItem)

                        let identity = firstItem[kSecImportItemIdentity as String] as! SecIdentity?
                        print("identity: \(identity ?? "" as! SecIdentity)")
                    }
}

main.run()

//struct P12Command: CommandType {
//    func run(_ parser: ArgumentParser) throws {
//        let argument = parser.remainder
//    }
//}
//
//struct P12FileNameArgument: ArgumentConvertible {
//    let description: String = ""
//    init(parser: ArgumentParser) throws {
//        if parser.hasOption("f") {
//            let value = try parser.shiftValue(for: "f")
//
//        } else {
//            throw ArgumentError.missingValue(argument: "p12")
//        }
//    }
//}


/**  Commander End  */


//let currentDir = FileManager.default.currentDirectoryPath
//let arguments = CommandLine.arguments

// -h
//for ( _, argument) in arguments.enumerated() {
//    if argument.contains("-h") || argument.contains("-H") {
//        print("Usage:\n\n    $ p12_importer {file_path} [Option] {password}\n\nOptions:\n    -h   Help\n    -H   Help\n    -p   Pasword phrase\n\n")
//        exit(1)
//    }
//}

// .p12 or .mobileprovision
//var filePath = ""
//for (i, argument) in arguments.enumerated() {
//    if argument.hasSuffix(".p12") {
//        let fileName = arguments[i]
//        print("fileName: \(fileName)")
//        filePath = (currentDir as NSString).appendingPathComponent(fileName)
//        print("filePath: \(filePath)")
//        break
//    }
//}

//if filePath.isEmpty {
//    print("Could not find any file.\np12_importer {file_path} [-p] {password}")
//    exit(1)
//}
//
//let url = URL(fileURLWithPath: filePath)
//var data: Data!
//do {
//    data = try Data(contentsOf: url)
//    print("data: \(data.description)")
//} catch {
//    print("Could not find any file. [error: \(error)]\np12_importer {file_path} [-p] {password}")
//    exit(1)
//}
//
//// -p
//var password = ""
//for (i, argument) in arguments.enumerated() {
//    if argument == "-p" {
//        let nextIndex = i + 1
//        if arguments.count > nextIndex {
//            password = arguments[nextIndex]
//            let blind_password = (0..<password.count).map({ _ in "*" }).joined()
//            print("Password: \(blind_password)")
//            break
//        }
//    }
//}
//if password.isEmpty {
//    print("No password. Please try again.\np12_importer {file_path} [-p] {password}")
//    exit(1)
//}
//
//let options = [kSecImportExportPassphrase as String: password]
//
//var rawItems: CFArray?
//let status = SecPKCS12Import(data as CFData, options as CFDictionary, &rawItems)
//
//guard status == errSecSuccess else {
//    print("failed importing p12 file. [status: \(status)] \np12_importer {file_path} [-p] {password}")
//    exit(1)
//}
//
//let items = rawItems! as! Array<Dictionary<String, Any>>
//let firstItem = items[0]
//print(firstItem)
//
//let identity = firstItem[kSecImportItemIdentity as String] as! SecIdentity?
//print("identity: \(identity ?? "" as! SecIdentity)")
