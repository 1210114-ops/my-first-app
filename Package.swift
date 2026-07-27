// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AITerminalPro",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "AITerminalProLib", targets: ["AITerminalPro"])
    ],
    targets: [
        .target(
            name: "AITerminalPro",
            path: "Sources",
            resources: [
                .process("Metal/Shaders.metal")
            ]
        )
    ]
)
