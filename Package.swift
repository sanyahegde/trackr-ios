// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Trackr",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Trackr", targets: ["Trackr"])
    ],
    targets: [
        .target(name: "Trackr")
    ]
)

