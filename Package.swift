// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "GoogleTVRemote",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "GoogleTVRemote",
            targets: ["GoogleTVRemote"]
        )
    ],
    targets: [
        .target(
            name: "GoogleTVRemote",
            dependencies: [],
            path: "GoogleTVRemote"
        )
    ]
)
