// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Energize",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "Energize",
            targets: ["AppModule"],
            bundleIdentifier: "zeta.dev.Energize",
            teamIdentifier: "7U55BCTM6U",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .landscapeRight,
                .landscapeLeft
            ],
            capabilities: [
                .microphone(purposeString: "Enable blowing to rotate the blades")
            ],
            appCategory: .games
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)