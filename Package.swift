// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "PKCS12CLI",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(name: "p12_importer", targets: ["PKCS12CLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.9.1"),
    ],
    targets: [
        .target(name: "PKCS12CLI", dependencies: ["Commander"])
    ]
)

